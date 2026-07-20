# syntax=docker/dockerfile:1
#
# api_proxy — travel-project 외부 API 프록시 백엔드
# 빌드 컨텍스트: packages/api_proxy 단독 (워크스페이스 나머지 패키지와 무관하게 독립 빌드)
#   docker build -t travel-project/api-proxy:local packages/api_proxy
#
# 최종 이미지는 Dart 공식 문서가 권장하는 `scratch` + `/runtime/` 패턴을 사용합니다.
# (컴파일된 AOT 실행 파일이 필요로 하는 libc/libssl/CA 인증서 등을 빌드 스테이지와
#  동일한 dart:stable 이미지에서 그대로 가져오므로 별도 배포판 이미지와 조합할 때
#  생길 수 있는 glibc 버전 불일치 위험이 없습니다.)

FROM dart:stable AS build
WORKDIR /app

COPY pubspec.yaml ./
RUN dart pub get

COPY . .
RUN dart pub get --offline
RUN dart compile exe bin/server.dart -o bin/server

FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /app/bin/server /app/bin/server

EXPOSE 8080
ENTRYPOINT ["/app/bin/server"]
