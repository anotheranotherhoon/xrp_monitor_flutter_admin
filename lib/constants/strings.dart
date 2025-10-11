class AppStrings {
  // Auth Labels
  static const String email = '이메일';
  static const String password = '비밀번호';
  static const String passwordConfirm = '비밀번호 확인';
  static const String nickname = '닉네임';
  static const String login = '로그인';
  static const String signup = '회원가입';

  // Auth Placeholders
  static const String emailPlaceholder = 'example@email.com';
  static const String passwordPlaceholder = '비밀번호를 입력하세요';
  static const String passwordConfirmPlaceholder = '비밀번호를 다시 입력하세요';
  static const String nicknamePlaceholder = '사용할 닉네임을 입력하세요';

  // Auth Headers
  static const String loginSubtitle = '계정에 로그인하세요';
  static const String signupSubtitle = '새 계정을 만들어보세요';

  // Auth Links
  static const String noAccountQuestion = '계정이 없으신가요?';
  static const String hasAccountQuestion = '이미 계정이 있으신가요?';

  // Validation Messages
  static const String emailRequired = '이메일을 입력해주세요';
  static const String emailInvalid = '올바른 이메일 형식을 입력해주세요';
  static const String passwordRequired = '비밀번호를 입력해주세요';
  static const String passwordInvalid = '영문, 숫자, 특수문자를 포함해야 합니다';
  static const String passwordConfirmRequired = '비밀번호 확인을 입력해주세요';
  static const String passwordNotMatch = '비밀번호가 일치하지 않습니다';
  static const String nicknameRequired = '닉네임을 입력해주세요';
  static const String quantityRequired = '보유 수량을 입력해주세요';
  static const String quantityInvalid = '올바른 수량을 입력해주세요';
  static const String averagePriceRequired = '평균 매수가를 입력해주세요';
  static const String averagePriceInvalid = '올바른 가격을 입력해주세요';

  // Toast Messages
  static const String loginSuccess = '로그인 성공!';
  static const String loginFailure = '로그인에 실패했습니다';
  static const String signupSuccess = '회원가입 성공!';
  static const String signupFailure = '회원가입에 실패했습니다';
  static const String errorOccurred = '오류가 발생했습니다';

  // Dialog Messages
  static const String confirm = '확인';
  static const String cancel = '취소';
  static const String complete = '완료';
  static const String error = '오류';
  static const String notice = '안내';
  static const String logoutConfirm = '로그아웃 하시겠습니까?';
  static const String editComplete = '수정 완료되었습니다!';

  // Error Messages
  static const String checkingData = '확인중입니다.';
  static const String tweetLoadError = '트윗을 불러오는 중 오류가 발생했습니다.';
  static const String videoLoadError = '비디오를 불러오는 중 오류가 발생했습니다.';
  static const String loginError = '이메일 또는 비밀번호가 잘못되었습니다.';
  static const String loginErrorGeneral = '로그인 중 오류가 발생했습니다. 다시 시도해주세요.';
  static const String signupErrorTitle = '회원가입 실패';
  static const String signupErrorContent = '회원가입에 실패했습니다.';
  static const String portfolioError = '포트폴리오 수정에 실패했습니다. API 응답 오류';
  static const String portfolioQueryError = '포트폴리오 조회 실패';

  // Button Labels
  static const String editPortfolio = '포트폴리오 수정';

  static const String xrpCurrentPrice = 'XRP 현재가';
  static const String xrpHoldings = 'XRP 보유량';
  static const String xrpAveragePrice = '평균 매수가';
  static const String xrpMemo = '메모';

  static const String memoPlaceholder = '메모';



  // webSocket Connect
  static const String webSocketConnecting = '웹소켓 연결 중...';
  static const String webSocketConnectingError = '연결 오류가 발생했습니다.';

  //
  static const String valuationGainLoss = '평가손익';
  static const String roi = '수익률';

  //Unit
  static const String krwUnit = 'KRW';
  static const String xrtUnit = 'XRP';

  //lazyload
  static const String newsLazyLoad = '뉴스 불러오는 중...';
  static const String ytLazyLoad = '유튜브 정보 불러오는 중...';
  static const String twitterLazyLoad = 'x 불러오는 중...';

  static const String tweetEmpty = '트위터를 찾을 수 없습니다.';

  //version_error

  static const String systemStatus = '시스템 점검';
  static const String updateStatus = '업데이트 안내';
  static const String updateTextStatus = '최신버전의 앱이 존재합니다.\n업데이트를 진행하시겠습니까?';
  static const String systemTextStatus = '보다 안정적인 서비스를 위한 시스템 점검중입니다.\n일시적으로 모든 서비스 이용이 제한되오니 양해 부탁드립니다.';

  // Additional UI Strings
  static const String connecting = '연결 중...';
  static const String waitingData = '데이터를 기다리는 중...';
  static const String loadingChartData = '차트 데이터 로딩 중...';
  static const String cannotPlayVideo = '동영상을 재생할 수 없습니다.';
  static const String videoInfo = '영상 정보';
  static const String ripple = '리플';
  static const String twitterOpenFailed = '트위터 열기 실패';
  static const String portfolioLoadingError = '포트폴리오 로딩 오류';
  static const String editFailed = '수정에 실패했습니다';
  static const String portfolioQueryFailed = '포트폴리오 조회 실패';
  static const String youtubeQueryFailed = '유튜브 정보 조회 실패';
  static const String newsQueryFailed = '뉴스 정보 조회 실패';
  static const String signupFailed = '회원가입 실패';
  static const String signupFailedContent = '회원가입에 실패했습니다.';
  static const String loginFailed = '로그인 실패';
  static const String loginFailedContent = '이메일 또는 비밀번호가 잘못되었습니다.';

  // Validation Length Messages
  static String nicknameTooShort(int min) => '닉네임은 $min자 이상이어야 합니다';
  static String nicknameTooLong(int max) => '닉네임은 $max자 이하여야 합니다';
  static String passwordTooShort(int min) => '비밀번호는 $min자 이상이어야 합니다';
  static String errorWithDetails(String details) => '오류가 발생했습니다: $details';
}