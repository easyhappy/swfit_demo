import AVFoundation

extension CMTime {
    var isValid:Bool {
        return (flags & .Valid) != nil
    }
}
