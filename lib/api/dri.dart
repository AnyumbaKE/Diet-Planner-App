import 'dart:core';
import 'package:ari_utils/ari_utils.dart';
import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:client_cookie/client_cookie.dart';
import 'package:dio/dio.dart';
// import 'package:dio_cookie_manager/dio_cookie_manager.dart';
// import 'package:cookie_jar/cookie_jar.dart';
import 'package:diet_planner/api/nutritionix.dart';
import 'package:diet_planner/domain.dart';

final valueUnitSearch = RegExp(r'^([0-9.,]+) (\w+)');
final macroSearch = RegExp(r'^\d+ - \d+ \w+');
const driCalcBaseUrl =
    'https://www.nal.usda.gov/human-nutrition-and-food-safety/dri-calculator';
const Map<String, String> constDirPostDict = {
  'measurement_units': 'std',
  'age_type': 'yrs',
  'cm': '',
  'kilos': '',
  'op': 'Submit',
  'form_id': 'dri_calculator_form'
};
const List<String> exclusionList = [
  'Sex',
  'Age',
  'Height',
  'Weight',
  'Activity level',
  'Dietary Cholesterol',
  'Body Mass Index (BMI) More Information About Bmi',
  'Macronutrient',
  'Saturated fatty acids',
  'Trans fatty acids',
  'Vitamin',
  'Total Water',
  'Carotenoids',
  'Mineral',
  'Essential',
  'Non-Essential',
  'Arsenic',
  'Silicon',
  'Sulfate',
  'Pregnancy/Lactation status'
];

num? toNum(number) {
  if (number is! String) {
    return number;
  }
  final answer = double.parse(number.replaceAll(',', ''));
  if (answer.isInt) {
    return answer.toInt();
  } else {
    return answer;
  }
}

Future<String> driCalc(AnthroMetrics metrics) async {
  // CookieJar cookieJar = CookieJar();
  Dio dio = Dio();
  // dio.interceptors.add(CookieManager(cookieJar));
  try {
    Response baseResponse = await dio.get(driCalcBaseUrl,
        options: Options(headers: {
          'Accept':
              ' text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8',
          'Accept-Encoding': ' gzip, deflate, br',
          'Accept-Language': ' en-US,en;q=0.5',
          'Connection': ' keep-alive',
          'Content-Type': ' application/x-www-form-urlencoded',
          // WEBMONSESSION NOT NEEDED AT ALL
          // GUID NOT NEEDED
          'Origin': ' https://www.nal.usda.gov',
          'Prefer': ' safe',
          'Referer':
              ' https://www.nal.usda.gov/human-nutrition-and-food-safety/dri-calculator',
          'Sec-Fetch-Dest': ' document',
          'Sec-Fetch-Mode': ' navigate',
          'Sec-Fetch-Site': ' same-origin',
          'Sec-Fetch-User': ' ?1',
          'Upgrade-Insecure-Requests': ' 1',
          'User-Agent':
              ' Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/109.0',
        }));
    // Needs a base cookie to work as above ^ find out what makes it work
    // print('-------------------');
    // print(baseResponse.headers);
    // print(baseResponse.headers.map['set-cookie']![0]);
    // print(baseResponse.headers.map['set-cookie']![1]);

    // print(cookieJar);
    List<ClientCookie> clientCookie = baseResponse.headers['set-cookie']!
        .map((e) => ClientCookie.fromSetCookie(e))
        .toList();
    // print(clientCookie.map((e) => e.toReqHeader).toList());
    // print({'Cookie': clientCookie.map((e) => e.toReqHeader).toList().join('; ')});
    Map<String, String> baseDict = Map<String, String>.from(constDirPostDict);
    baseDict['form_build_id'] = getFormBuildId(baseResponse.data);
    final Map<String, String> postDict = Map<String, String>.from(baseDict)
      ..addAll(metrics.toDictForPost());
    // print(postDict);
    Response driResponse = await dio.post(driCalcBaseUrl,
        data: FormData.fromMap(postDict),
        options: Options(headers: {
          'Accept':
              ' text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8',
          'Accept-Encoding': ' gzip, deflate, br',
          'Accept-Language': ' en-US,en;q=0.5',
          'Connection': ' keep-alive',
          'Content-Type': ' application/x-www-form-urlencoded',
          // WEBMONSESSION NOT NEEDED AT ALL
          // GUID NOT NEEDED
          'Cookie':
              ' ApplicationGatewayAffinityCORS=${clientCookie[0].value}; ApplicationGatewayAffinity=${clientCookie[0].value}; SSESS36ddc8e3532cfd4477f8a08bedf459b4=af17rFmPXaXK3YTkaWNbwIrnR2fMGr7uft1GZL58vgI-BBKF',
          'Origin': ' https://www.nal.usda.gov',
          'Prefer': ' safe',
          'Referer':
              ' https://www.nal.usda.gov/human-nutrition-and-food-safety/dri-calculator',
          'Sec-Fetch-Dest': ' document',
          'Sec-Fetch-Mode': ' navigate',
          'Sec-Fetch-Site': ' same-origin',
          'Sec-Fetch-User': ' ?1',
          'Upgrade-Insecure-Requests': ' 1',
          'User-Agent':
              ' Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/109.0',
        })
        // options: Options(headers: {'cookie': clientCookie.map((e) => e.toReqHeader).toList().join('; ')})
        // options: Options(headers: {'Cookie': '${baseResponse.headers.map['set-cookie']![0]}${baseResponse.headers.map['set-cookie']![1]}'})
        );
    // print('---------------------------------------------');
    // print(driResponse.headers);
    return driResponse.data;
  } on DioError catch (err) {
    throw getApiException(err);
  }
}

String getFormBuildId(String html) {
  RegExp regex = RegExp(r'(?<="form_build_id" value=")\S+(?=")');
  return regex.firstMatch(html)?.group(0) ?? '';
}

List<DRI> parseDRI(String dri, AnthroMetrics anthro) {
  List<DRI> driList = [];
  BeautifulSoup soup = BeautifulSoup(dri);
  // print(soup.findAll('tr'));
  for (Bs4Element tr in soup.findAll('tr')) {
    List<String> currentText =
        tr.text.trim().split('\n').map((e) => e.trim()).toList();
    // print(currentText);
    if (exclusionList.contains(currentText[0])) {
      continue;
    } else if (currentText.length == 2) {
      driList.add(DRI.driMacro(currentText, anthro));
    } else {
      driList.add(DRI.driMicro(currentText));
    }
  }
  return driList;
}

int toInches(int feet, int inches) {
  return (feet * 12) + inches;
}

// Nutrients dris2Nutrients(List<DRI> dris){
//   Map<String, Nutrient> map = {};
//   for (DRI dri in dris){
//     String current = dri.name.replaceAll(' ', '');
//     switch(current){
//       case 'α-Linolenic Acid': current = 'ALA'; break;
//       case 'α-Linolenic Acid': current = 'ALA'; break;
//       case 'α-Linolenic Acid': current = 'ALA'; break;
//       case 'α-Linolenic Acid': current = 'ALA'; break;
//       default: current = current;
//
//     }
//   }
// }

List<DRI> extraDRIS = [
  DRI('EPA', dri: .2, upperLimit: 1.8, unit: 'g'),
  DRI('DHA', dri: .2, upperLimit: 1.8, unit: 'g'),
  DRI('DPA', dri: .05, unit: 'g'),
  DRI('Trans Fat', unit: 'g', upperLimit: 1),
  DRI('Cholesterol', unit: 'mg', upperLimit: 300),
];

Map<String, DRI> prepDRIMapFromAPI(List<DRI> list) {
  list.addAll(extraDRIS);
  Map<String, DRI> newMap = <String, DRI>{};
  for (DRI dri in list) {
    if (dri.name.contains(' ')) {
      if (dri.name == 'α-Linolenic Acid') {
        newMap['ala'] = dri;
        continue;
      } else if (dri.name == 'Total Fiber') {
        newMap['fiber'] = dri;
        continue;
      }
      List<String> preSpace_postSpace = dri.name.split(' ');
      preSpace_postSpace[0] = preSpace_postSpace[0].toLowerCase();
      newMap[preSpace_postSpace[0] + preSpace_postSpace[1]] = dri;
    } else {
      if (dri.name == 'Fat') {
        dri.name = 'Total Fat';
        newMap['totalFat'] = dri;
        continue;
      }
      newMap[dri.name.toLowerCase()] = dri;
    }
  }
  return newMap;
}
