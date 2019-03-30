package haxe.ui.backend;

import haxe.io.Bytes;
import haxe.ui.assets.FontInfo;
import haxe.ui.assets.ImageInfo;
import haxe.ui.backend.html5.util.FontDetect;
import js.Browser;

class AssetsImpl extends AssetsBase {
    private override function getImageInternal(resourceId:String, callback:ImageInfo->Void) {
        var bytes = Resource.getBytes(resourceId);
        if (bytes != null) {
            callback(null);
            return;
        }

        var image = Browser.document.createImageElement();
        image.onload = function(e) {
            var imageInfo:ImageInfo = {
                width: image.width,
                height: image.height,
                data: cast image
            }
            callback(imageInfo);
        }
        image.onerror = function(e) {
            callback(null);
        }
        image.src = resourceId;

    }

    private override function getImageFromHaxeResource(resourceId:String, callback:String->ImageInfo->Void) {
        var bytes = Resource.getBytes(resourceId);
        imageFromBytes(bytes, function(imageInfo) {
            callback(resourceId, imageInfo);
        });
    }

    public override function imageFromBytes(bytes:Bytes, callback:ImageInfo->Void) {
        if (bytes == null) {
            callback(null);
            return;
        }

        var image = Browser.document.createImageElement();
        image.onload = function(e) {
            var imageInfo:ImageInfo = {
                width: image.width,
                height: image.height,
                data: cast image
            }
            callback(imageInfo);
        }
        image.onerror = function(e) {
            Browser.window.console.log(e);
            callback(null);
        }
        
        var base64:String = haxe.crypto.Base64.encode(bytes);
        image.src = "data:;base64," + base64;
    }
    
    private override function getFontInternal(resourceId:String, callback:FontInfo->Void) {
        FontDetect.onFontLoaded(resourceId, function(f) {
            var fontInfo = {
                data: f
            }
            callback(fontInfo);
        }, function(f) {
            callback(null);
        });
    }
}