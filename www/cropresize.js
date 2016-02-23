var ImageCropResizer = function() {

};

ImageCropResizer.FORMAT_JPG = "jpg";
ImageCropResizer.FORMAT_PNG = "png";

/**
 * Crop/Resize an image
 * @param success - success callback, will receive the data sent from the native plugin
 * @param fail - error callback, will receive an error string describing what went wrong
 * @param imageData - The image data, either base64 or local url
 * @param width - width factor / width in pixels (if one of height/width is 0, will resize to fit to the other while keeping aspect ratio)
 * @param height - height factor / height in pixels
 * @param options extra options -  
 *              format : file format to use (ImageResizer.FORMAT_JPG/ImageResizer.FORMAT_PNG) - defaults to JPG
 *              quality : INTEGER, compression quality - defaults to 75
 * @returns JSON Object with the following parameters:
 *              imageData : Base64 of the resized image || OR filename if storeImage = true
 *              height : height of the resized image
 *              width: width of the resized image
 */
ImageCropResizer.prototype.cropResizeImage = function(success, fail, imageData, width, height, options) {
  if (!options) {
      options = {};
  }
    
  var params = {
      data: imageData,
      width: width ? width : 0,
      height: height ? height : 0,
      format: options.format ? options.format : ImageCropResizer.FORMAT_JPG,
      quality: options.quality ? options.quality : 75
  };

  return cordova.exec(success, fail, "ImageCropResizePlugin", "cropResizeImage", [params]);
};

window.ImageCropResizer = ImageCropResizer;
window.ImageCropResizer = new ImageCropResizer();
module.exports = new ImageCropResizer();