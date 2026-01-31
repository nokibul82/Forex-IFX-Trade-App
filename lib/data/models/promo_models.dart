import 'package:xml/xml.dart';

class PromoRequest {
  final String lang;

  PromoRequest({required this.lang});

  String toXml() {
    return '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <GetCCPromo xmlns="http://tempuri.org/">
      <lang>en</lang>
    </GetCCPromo>
  </soap:Body>
</soap:Envelope>
''';
  }
}

class PromoItem {
  final String title;
  final String description;
  final String imageUrl;
  final String detailUrl;
  final DateTime? startDate;
  final DateTime? endDate;

  PromoItem({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.detailUrl,
    this.startDate,
    this.endDate,
  });

  factory PromoItem.fromXml(Map<String, dynamic> xml) {
    // Extract and process the image URL
    String imageUrl = xml['ImageUrl']?.toString() ?? '';

    // Replace the domain if needed
    if (imageUrl.contains('forex-images.instaforex.com')) {
      imageUrl = imageUrl.replaceAll(
        'forex-images.instaforex.com',
        'forex-images.ifxdb.com',
      );
    }

    // Parse dates if available
    DateTime? startDate;
    DateTime? endDate;

    if (xml['StartDate'] != null && xml['StartDate'].toString().isNotEmpty) {
      try {
        startDate = DateTime.parse(xml['StartDate'].toString());
      } catch (e) {
        startDate = null;
      }
    }

    if (xml['EndDate'] != null && xml['EndDate'].toString().isNotEmpty) {
      try {
        endDate = DateTime.parse(xml['EndDate'].toString());
      } catch (e) {
        endDate = null;
      }
    }

    return PromoItem(
      title: xml['Title']?.toString() ?? 'No Title',
      description: xml['Description']?.toString() ?? 'No description available',
      imageUrl: imageUrl,
      detailUrl: xml['DetailUrl']?.toString() ?? '',
      startDate: startDate,
      endDate: endDate,
    );
  }
}

class PromoResponse {
  final List<PromoItem> items;

  PromoResponse({required this.items});

  // factory PromoResponse.fromXml(String xmlString) {
  //   // Simple XML parsing for demo purposes
  //   // In a real app, you'd use an XML parser package like xml
  //   final items = <PromoItem>[];
  //
  //   // Extract items between <PromoItem> tags
  //   final itemPattern = RegExp(r'<PromoItem>(.*?)</PromoItem>', dotAll: true);
  //   final itemMatches = itemPattern.allMatches(xmlString);
  //
  //   for (final match in itemMatches) {
  //     final itemXml = match.group(1)!;
  //
  //     final titleMatch = RegExp(r'<Title>(.*?)</Title>').firstMatch(itemXml);
  //     final descMatch = RegExp(r'<Description>(.*?)</Description>').firstMatch(itemXml);
  //     final imageMatch = RegExp(r'<ImageUrl>(.*?)</ImageUrl>').firstMatch(itemXml);
  //     final urlMatch = RegExp(r'<DetailUrl>(.*?)</DetailUrl>').firstMatch(itemXml);
  //     final startMatch = RegExp(r'<StartDate>(.*?)</StartDate>').firstMatch(itemXml);
  //     final endMatch = RegExp(r'<EndDate>(.*?)</EndDate>').firstMatch(itemXml);
  //
  //     final item = PromoItem(
  //       title: titleMatch?.group(1)?.replaceAll('![CDATA[', '')?.replaceAll(']]', '') ?? 'No Title',
  //       description: descMatch?.group(1)?.replaceAll('![CDATA[', '')?.replaceAll(']]', '') ?? '',
  //       imageUrl: imageMatch?.group(1)?.replaceAll('![CDATA[', '')?.replaceAll(']]', '') ?? '',
  //       detailUrl: urlMatch?.group(1)?.replaceAll('![CDATA[', '')?.replaceAll(']]', '') ?? '',
  //       startDate: startMatch?.group(1)?.isNotEmpty == true
  //           ? DateTime.tryParse(startMatch!.group(1)!)
  //           : null,
  //       endDate: endMatch?.group(1)?.isNotEmpty == true
  //           ? DateTime.tryParse(endMatch!.group(1)!)
  //           : null,
  //     );
  //
  //     items.add(item);
  //   }
  //
  //   return PromoResponse(items: items);
  // }

  factory PromoResponse.fromXml(String xmlString) {
    final document = XmlDocument.parse(xmlString);
    final items = <PromoItem>[];

    // Find all PromoItem elements
    final promoItems = document.findAllElements('PromoItem');

    for (final element in promoItems) {
      final title = element.findElements('Title').first.innerText;
      final description = element.findElements('Description').first.innerText;
      final imageUrl = element.findElements('ImageUrl').first.innerText;
      final detailUrl = element.findElements('DetailUrl').first.innerText;

      final startDateStr = element.findElements('StartDate').first.innerText;
      final endDateStr = element.findElements('EndDate').first.innerText;

      DateTime? startDate;
      DateTime? endDate;

      if (startDateStr.isNotEmpty) {
        startDate = DateTime.tryParse(startDateStr);
      }

      if (endDateStr.isNotEmpty) {
        endDate = DateTime.tryParse(endDateStr);
      }

      // Process image URL
      String processedImageUrl = imageUrl;
      if (processedImageUrl.contains('forex-images.instaforex.com')) {
        processedImageUrl = processedImageUrl.replaceAll(
          'forex-images.instaforex.com',
          'forex-images.ifxdb.com',
        );
      }

      items.add(PromoItem(
        title: title,
        description: description,
        imageUrl: processedImageUrl,
        detailUrl: detailUrl,
        startDate: startDate,
        endDate: endDate,
      ));
    }

    return PromoResponse(items: items);
  }
}