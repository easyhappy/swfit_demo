//
//  TopicDetailViewController.m
//  Coding_iOS
//
//  Created by 王 原闯 on 14-8-27.
//  Copyright (c) 2014年 Coding. All rights reserved.
//

#define kCellIdentifier_TopicContent @"TopicContentCell"
#define kCellIdentifier_TopicComment @"TopicCommentCell"

#import "TopicDetailViewController.h"
#import "TopicContentCell.h"
#import "TopicCommentCell.h"
#import "ODRefreshControl.h"
#import "Coding_NetAPIManager.h"
#import "RegexKitLite.h"
#import "TopicDetailViewController.h"
#import "ProjectViewController.h"
#import "UserInfoViewController.h"
#import "TweetDetailViewController.h"
#import "MJPhotoBrowser.h"
#import "SVPullToRefresh.h"
#import "EditTaskViewController.h"
#import "WebViewController.h"
#import "EditTopicViewController.h"

@interface TopicDetailViewController ()
@property (strong, nonatomic) UITableView *myTableView;
@property (nonatomic, strong) ODRefreshControl *refreshControl;

//评论
@property (nonatomic, strong) UIMessageInputView *myMsgInputView;
@property (nonatomic, strong) ProjectTopic *toComment;
@property (nonatomic, strong) UIView *commentSender;

//链接
@property (strong, nonatomic) NSString *clickedAutoLinkStr;

@end

@implementation TopicDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"讨论详情";
    
    _myTableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        tableView.backgroundColor = [UIColor clearColor];
        tableView.delegate = self;
        tableView.dataSource = self;
        [tableView registerClass:[TopicContentCell class] forCellReuseIdentifier:kCellIdentifier_TopicContent];
        [tableView registerClass:[TopicCommentCell class] forCellReuseIdentifier:kCellIdentifier_TopicComment];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        tableView;
    });
    _refreshControl = [[ODRefreshControl alloc] initInScrollView:self.myTableView];
    [_refreshControl addTarget:self action:@selector(refreshTopic) forControlEvents:UIControlEventValueChanged];
    
    //评论
    __weak typeof(self) weakSelf = self;
    _myMsgInputView = [UIMessageInputView messageInputViewWithType:UIMessageInputViewTypeSimple];
    _myMsgInputView.contentType = UIMessageInputViewContentTypeTopic;
    _myMsgInputView.isAlwaysShow = YES;
    _myMsgInputView.delegate = self;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0,CGRectGetHeight(_myMsgInputView.frame), 0.0);
    self.myTableView.contentInset = contentInsets;
    self.myTableView.scrollIndicatorInsets = contentInsets;
    
    [_myTableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf refreshMore];
    }];
    if (_curTopic && _curTopic.project) {
        _myMsgInputView.curProject = _curTopic.project;
        _myMsgInputView.commentOfId = _curTopic.id;
    }
    [self refreshTopic];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (_myMsgInputView) {
        [_myMsgInputView prepareToDismiss];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //    键盘
    if (_myMsgInputView) {
        if (!_myMsgInputView.toUser) {
            _myMsgInputView.toUser = nil;
        }
        [_myMsgInputView prepareToShow];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark nav 
- (void)configNavBtn{
    [self.navigationItem setRightBarButtonItem:[self.curTopic canEdit]? [UIBarButtonItem itemWithBtnTitle:@"编辑" target:self action:@selector(editBtnClicked)]: nil animated:YES];
}

- (void)editBtnClicked{
    EditTopicViewController *vc = [[EditTopicViewController alloc] init];
    vc.curProTopic = self.curTopic;
    vc.type = TopicEditTypeModify;
    
    __weak typeof(self) weakSelf = self;
    vc.topicChangedBlock = ^(ProjectTopic *topic, TopicEditType type){
        [weakSelf refreshTopic];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark UIMessageInputViewDelegate
- (void)messageInputView:(UIMessageInputView *)inputView sendText:(NSString *)text{
    [self sendCommentMessage:text];
}
- (void)messageInputView:(UIMessageInputView *)inputView heightToBottomChenged:(CGFloat)heightToBottom{
    [UIView animateWithDuration:0.25 delay:0.0f options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
        UIEdgeInsets contentInsets= UIEdgeInsetsMake(0.0, 0.0, heightToBottom, 0.0);;
        CGFloat msgInputY = kScreen_Height - heightToBottom - 64;
        
        self.myTableView.contentInset = contentInsets;
        self.myTableView.scrollIndicatorInsets = contentInsets;
        
        if ([_commentSender isKindOfClass:[UIView class]] && !self.myTableView.isDragging && heightToBottom > 60) {
            UIView *senderView = _commentSender;
            CGFloat senderViewBottom = [_myTableView convertPoint:CGPointZero fromView:senderView].y+ CGRectGetMaxY(senderView.bounds);
            CGFloat contentOffsetY = MAX(0, senderViewBottom- msgInputY);
            [self.myTableView setContentOffset:CGPointMake(0, contentOffsetY) animated:YES];
        }
    } completion:nil];
}

#pragma mark Refresh M

- (void)refreshComments{
    if (_curTopic.isLoading) {
        return;
    }
    _curTopic.willLoadMore = NO;
    [self sendRequest];
}

- (void)refreshTopic{
    if (_curTopic.isTopicLoading) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    [[Coding_NetAPIManager sharedManager] request_ProjectTopic_WithObj:_curTopic andBlock:^(id data, NSError *error) {
        [self.refreshControl endRefreshing];
        if (data) {
            weakSelf.curTopic = data;
            
            weakSelf.myMsgInputView.curProject = weakSelf.curTopic.project;
            weakSelf.myMsgInputView.commentOfId = _curTopic.id;
            weakSelf.myMsgInputView.toUser = nil;
            [weakSelf configNavBtn];
            
            [weakSelf.myTableView reloadData];
            [weakSelf refreshComments];
        }
    }];
}

- (void)refreshMore{
    if (_curTopic.isLoading || !_curTopic.canLoadMore) {
        [self.myTableView.infiniteScrollingView stopAnimating];
        return;
    }
    _curTopic.willLoadMore = YES;
    [self sendRequest];
}

- (void)sendRequest{
    __weak typeof(self) weakSelf = self;
    [[Coding_NetAPIManager sharedManager] request_Comments_WithProjectTpoic:self.curTopic andBlock:^(id data, NSError *error) {
        [weakSelf.refreshControl endRefreshing];
        [weakSelf.myTableView.infiniteScrollingView stopAnimating];
        if (data) {
            [weakSelf.curTopic configWithComments:data];
            [weakSelf.myTableView reloadData];
            weakSelf.myTableView.showsInfiniteScrolling = weakSelf.curTopic.canLoadMore;
        }
    }];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (scrollView == _myTableView) {
        [self.myMsgInputView isAndResignFirstResponder];
    }
}

#pragma mark Table M
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger row = 0;
    if (_curTopic) {
        row = 1;
        if (_curTopic.comments && _curTopic.comments.list && [_curTopic.comments.list count] > 0) {
            row = [_curTopic.comments.list count] +1;
        }
    }
    return row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        TopicContentCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_TopicContent forIndexPath:indexPath];
        cell.curTopic = self.curTopic;
        __weak typeof(self) weakSelf = self;
        cell.commentTopicBlock = ^(ProjectTopic *curTopic, id sender){
            [weakSelf doCommentToTopic:nil sender:sender];
        };
        cell.cellHeightChangedBlock = ^(){
            [weakSelf.myTableView reloadData];
        };
        cell.loadRequestBlock = ^(NSURLRequest *curRequest){
            [weakSelf loadRequest:curRequest];
        };
        cell.deleteTopicBlock = ^(ProjectTopic *curTopic){
            UIActionSheet *actionSheet = [UIActionSheet bk_actionSheetCustomWithTitle:@"删除此讨论" buttonTitles:nil destructiveTitle:@"确认删除" cancelTitle:@"取消" andDidDismissBlock:^(UIActionSheet *sheet, NSInteger index) {
                if (index == 0) {
                    [weakSelf deleteTopic:weakSelf.curTopic isComment:NO];
                }
            }];
            [actionSheet showInView:kKeyWindow];
        };
        [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:0];
        return cell;
    }else{
        TopicCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_TopicComment forIndexPath:indexPath];
        ProjectTopic *toComment = [_curTopic.comments.list objectAtIndex:indexPath.row-1];
        cell.toComment = toComment;
        [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:45];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cellHeight = 0;
    if (indexPath.row == 0) {
        cellHeight = [TopicContentCell cellHeightWithObj:self.curTopic];
    }else{
        ProjectTopic *toComment = [_curTopic.comments.list objectAtIndex:indexPath.row - 1];
        cellHeight = [TopicCommentCell cellHeightWithObj:toComment];
    }
    return cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row != 0) {
        ProjectTopic *toComment = [_curTopic.comments.list objectAtIndex:indexPath.row-1];
        [self doCommentToTopic:toComment sender:[tableView cellForRowAtIndexPath:indexPath]];
    }
}

- (void)doCommentToTopic:(ProjectTopic *)toComment sender:(id)sender{
    if ([self.myMsgInputView isAndResignFirstResponder]) {
        return ;
    }
    _toComment = toComment;
    _commentSender = sender;
    
    _myMsgInputView.toUser = toComment.owner;

    if (_toComment) {
        if (_toComment.owner_id.intValue == [Login curLoginUser].id.intValue) {
            ESWeakSelf
            UIActionSheet *actionSheet = [UIActionSheet bk_actionSheetCustomWithTitle:@"删除此评论" buttonTitles:nil destructiveTitle:@"确认删除" cancelTitle:@"取消" andDidDismissBlock:^(UIActionSheet *sheet, NSInteger index) {
                ESStrongSelf
                if (index == 0) {
                    [_self deleteTopic:_self.toComment isComment:YES];
                }
            }];
            [actionSheet showInView:kKeyWindow];
            return;
        }
    }
    [_myMsgInputView notAndBecomeFirstResponder];
}

#pragma mark Delete M
- (void)deleteTopic:(ProjectTopic *)curTopic isComment:(BOOL)isC{
    if (curTopic) {
        __weak typeof(self) weakSelf = self;
        [[Coding_NetAPIManager sharedManager] request_ProjectTopic_Delete_WithObj:curTopic andBlock:^(id data, NSError *error) {
            if (data) {
                if (isC) {
                    [weakSelf.curTopic.comments.list removeObject:_toComment];
                    [weakSelf.myTableView reloadData];
                }else{
                    if (weakSelf.deleteTopicBlock) {
                        weakSelf.deleteTopicBlock(weakSelf.curTopic);
                    }
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }
            }
        }];
    }
}

#pragma mark Comment To Topic
- (void)sendCommentMessage:(id)obj{
    __weak typeof(self) weakSelf = self;
    if (_toComment) {
        _curTopic.nextCommentStr = [NSString stringWithFormat:@"@%@ : %@", _toComment.owner.name, obj];
    }else{
        _curTopic.nextCommentStr = obj;
    }
    [[Coding_NetAPIManager sharedManager] request_DoComment_WithProjectTpoic:_curTopic andBlock:^(id data, NSError *error) {
        if (data) {
            [weakSelf.curTopic configWithComment:data];
            [weakSelf.myTableView reloadData];
        }
    }];
    {
        _toComment = nil;
        _commentSender = nil;
    }
    [self.myMsgInputView isAndResignFirstResponder];
}

#pragma mark loadCellRequest
- (void)loadRequest:(NSURLRequest *)curRequest{
    NSString *linkStr = curRequest.URL.absoluteString;
    NSLog(@"\n linkStr : %@", linkStr);
    [self analyseLinkStr:linkStr];
}

- (void)analyseLinkStr:(NSString *)linkStr{
    UIViewController *vc = [BaseViewController analyseVCFromLinkStr:linkStr];
    if (vc) {
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        //网址
        WebViewController *webVc = [WebViewController webVCWithUrlStr:linkStr];
        [self.navigationController pushViewController:webVc animated:YES];
    }
}

- (void)dealloc
{
    _myTableView.delegate = nil;
    _myTableView.dataSource = nil;
}

@end
