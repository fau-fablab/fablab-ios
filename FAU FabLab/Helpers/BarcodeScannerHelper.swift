import UIKit
import AVFoundation
import RSBarcodes

class BarcodeScannerHelper{
    class func getProductIdFromBarcode(barcode: AVMetadataMachineReadableCodeObject) -> String{
        let productId = barcode.stringValue as NSString
        if (barcode.type == AVMetadataObjectTypeEAN13Code) {
            return productId.substringWithRange(NSRange(location: 8, length: 4))
        } else {
            return productId.substringWithRange(NSRange(location: 3, length: 4))
        }
    }
}
