
import 'product.dart';

class ProductsRepository {
  static List<Product> loadProducts(Category category) {
   List<Product> allProducts = <Product> [
      Product(
        id: 0,
        isFavorited: false,
        name: 'CBM',
        star: 4,
        address: '서울특별시 영등포구 영등포동 영중로 15',
        phoneNum: '02-2638-3000',
        descriptions: '화한 서울 도심에 위치한 코트야드 서울 타임스퀘어에서 특별한 호텔 경험을 선사해드립니다. 타임스퀘어 엔터테인먼트 복합단지에 위치한 호텔로 서울 시내의 수많은 관광지에서 가깝습니다. 편안함과 스타일을 모두 갖춘 도심 호텔 객실이나 스위트에서는 무료 와이파이와 대리석 욕실, 미니 냉장고, 고급 침구를 제공합니다.',
      ),
      Product(
        id: 1,
        isFavorited: false,
        name: 'Standford Hotel',
        star: 4,
        address: '서울특별시 마포구 상암동 월드컵북로58길 15',
        phoneNum:  '02-6016-0001',
        descriptions: '디지털/방송 비즈니스의 요람 상암동 DMC 유일의 특급 비즈니스호텔인 스탠포드호텔 서울은 2011년 가을 오픈하여 비즈니스 고객을 위한 스위트룸, 발코니룸을 포함한 239개의 객실과 세미나, 기업회의, 결혼식 등을 위한 다양한 연회공간, 3층 전 층을 활용한 피트니스 클럽 및 레스토랑, 그릴&바 등의 시설을 갖추고 있습니다.',
      ),
      Product(
        id: 2,
        isFavorited: false,
        name: 'Ramada Anchor',
        star: 4,
        address: '서울특별시 동대문구 용신동 왕산로 22',
        phoneNum:  '02-2116-6000',
        descriptions: '현대적이고 감각적인 객실 디자인으로 편안함과 아늑함을 선사해 드립니다. 한식, 일식, 중식, 양식 등 다양한 음식과 현지 주방장들이 선사하는 미각을 선보입니다.',
      ),
      Product(
        id: 3,
        isFavorited: false,
        name: 'Four Points',
        star: 4,
        address: '서울특별시 용산구 동자동 37-85',
        phoneNum: '02-6070-7000',
        descriptions: '활기 넘치는 용산구에 자리한 포포인츠 바이 쉐라톤 서울, 남산에서는 비즈니스와 자유여행객 모두를 환영합니다. 복합 건물 상층에 자리한 모던한 호텔로 건물 아래층에 위치한 사무실과 숍을 편리하게 이용하실 수 있습니다. KTX와 공항철도를 이용할 수 있는 서울역에서 도보 거리에 있는 도심 호텔로 명동과 용산미군기지, 국립중앙박물관, 야간 엔터테인먼트로 유명한 이태원에서 몇 분 거리에 있습니다. ',
      ),
      Product(
        id: 4,
        isFavorited: false,
        name: 'Shilla Stay',
        star: 5,
        address: '서울특별시 강남구 언주로 517',
        phoneNum:  '02-2233-3131',
        descriptions: '서울의 중심부에 위치한 삼성 그룹의 신라스테이 광화문은 무료 WiFi를 갖춘 객실, 뷔페 레스토랑, 무료 주차장을 제공합니다. 호텔에서 도보로 10분 거리에 지하철 종각역, 광화문역 및 안국역이 있습니다. 우아한 분위기의 각 객실은 평면 TV, 냉장고, 무료 생수 및 커피/차를 갖추고 있습니다. 전용 욕실에는 샤워 부스 또는 욕조가 있으며, 무료 세면도구 및 목욕 가운이 비치되어 있습니다.',
      ),
      Product(
        id: 5,
        isFavorited: false,
        name: 'The Designers',
        star: 3,
        address: '서울특별시 강남구 논현동 201-11',
        phoneNum:  '02-2017-4655',
        descriptions: '19층에 총 170개의 객실이 각각 구성돼 있으며 호텔 더 디자이너스 브랜드 중 가장 많은 객실과 고급 시설을 갖추고 있다. 특히 김완선, 강수지 등의 유명 셀러브리티들과 유명 공간 디자이너들이 함께 참여했으며 호텔 13층의 테라스 라운지를 비롯해 실내 라운지, 스파, 뷔페 레스토랑에서 세련되고 고급스러운 디자인을 느낄 수 있어 많은 이들의 관심을 불러 모았다.',
      ),
    ];
    if (category == Category.all) {
      return allProducts;
    } else {
      return allProducts.where((Product p) {
        return p.category == category;
      }).toList();
    }
  }
}
