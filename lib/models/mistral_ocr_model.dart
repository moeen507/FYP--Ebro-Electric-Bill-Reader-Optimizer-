class MistralOCRModel {
  List<Page> pages;
  String? model; // Make model nullable
  UsageInfo usage_info;
  String? markdownContents;
  MistralOCRModel({
    required this.pages,
    required this.model,
    required this.usage_info,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'pages': pages.map((x) => x.toMap()).toList(),
      'model': model,
      'usage_info': usage_info.toMap(),
    };
  }

  factory MistralOCRModel.fromJson(Map<String, dynamic> map) {
    return MistralOCRModel(
      pages: (map['pages'] as List)
          .map((x) => Page.fromMap(x as Map<String, dynamic>))
          .toList(),
      model: map['model'] != null
          ? map['model'] as String
          : null, // Handle null model
      usage_info: UsageInfo.fromMap(map['usage_info'] as Map<String, dynamic>),
    );
  }

  String replaceImagesInMarkdown(String markdownText, List<OCRImage> images) {
    // Replace image placeholders with base64 images
    for (var image in images) {
      final imageId = image.id;
      final imageBase64 = image.image_base64;

      markdownText = markdownText.replaceAll(
          "![${imageId}](${imageId})", "![${imageId}](${imageBase64})");
    }
    return markdownText;
  }

  String toMarkdownString() {
    List<String> content = [];
    for (Page page in this.pages) {
      String temp = replaceImagesInMarkdown(page.markdown, page.images);
      content.add(temp);
    }
    return content.join("\n\n");
  }
}

class Page {
  int index;
  String markdown;
  List<OCRImage> images;
  Dimensions dimensions;
  Page({
    required this.index,
    required this.markdown,
    required this.images,
    required this.dimensions,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'index': index,
      'markdown': markdown,
      'images': images.map((x) => x.toMap()).toList(),
      'dimensions': dimensions.toMap(),
    };
  }

  factory Page.fromMap(Map<String, dynamic> map) {
    return Page(
      index: map['index'] as int,
      markdown: map['markdown'] as String,
      images: (map['images'] as List)
          .map((x) => OCRImage.fromMap(x as Map<String, dynamic>))
          .toList(),
      dimensions: Dimensions.fromMap(map['dimensions'] as Map<String, dynamic>),
    );
  }
}

// Update OCRImage class to have nullable fields
class OCRImage {
  String id;
  int top_left_x;
  int top_left_y;
  int bottom_right_x;
  int bottom_right_y;
  String? image_base64;
  OCRImage({
    required this.id,
    required this.top_left_x,
    required this.top_left_y,
    required this.bottom_right_x,
    required this.bottom_right_y,
    required this.image_base64,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'top_left_x': top_left_x,
      'top_left_y': top_left_y,
      'bottom_right_x': bottom_right_x,
      'bottom_right_y': bottom_right_y,
      'image_base64': image_base64,
    };
  }

  factory OCRImage.fromMap(Map<String, dynamic> map) {
    return OCRImage(
      id: map['id'] as String,
      top_left_x: map['top_left_x'] as int,
      top_left_y: map['top_left_y'] as int,
      bottom_right_x: map['bottom_right_x'] as int,
      bottom_right_y: map['bottom_right_y'] as int,
      image_base64: map['image_base64'],
    );
  }
}

class Dimensions {
  int dpi;
  int height;
  int width;
  Dimensions({
    required this.dpi,
    required this.height,
    required this.width,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'dpi': dpi,
      'height': height,
      'width': width,
    };
  }

  factory Dimensions.fromMap(Map<String, dynamic> map) {
    return Dimensions(
      dpi: map['dpi'] as int,
      height: map['height'] as int,
      width: map['width'] as int,
    );
  }
}

class UsageInfo {
  int pages_processed;
  int? doc_size_bytes;
  UsageInfo({
    required this.pages_processed,
    this.doc_size_bytes,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'pages_processed': pages_processed,
      'doc_size_bytes': doc_size_bytes,
    };
  }

  factory UsageInfo.fromMap(Map<String, dynamic> map) {
    return UsageInfo(
      pages_processed: map['pages_processed'] as int,
      doc_size_bytes: map['doc_size_bytes'] as int?,
    );
  }

  @override
  String toString() {
    return 'UsageInfo(pages_processed: $pages_processed, doc_size_bytes: $doc_size_bytes)';
  }
}
