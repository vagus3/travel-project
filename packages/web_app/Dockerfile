# syntax=docker/dockerfile:1
#
# web_app — travel-project 웹 앱
# 빌드 컨텍스트: 저장소 루트 (pub workspace 해석에 packages/core 가 필요하기 때문)
#   docker build -f packages/web_app/Dockerfile -t travel-project/web-app:local .

FROM ghcr.io/cirruslabs/flutter:3.35.6 AS build
WORKDIR /workspace

# pub workspace 해석: 루트 매니페스트 + core(의존) + web_app(빌드 대상).
# mobile_app은 pubspec.yaml만 있으면 워크스페이스 멤버 목록 검증을 통과하므로
# android/ios 등 무거운 플랫폼 폴더는 복사하지 않습니다.
COPY pubspec.yaml pubspec.lock* ./
COPY packages/core packages/core
COPY packages/web_app packages/web_app
COPY packages/mobile_app/pubspec.yaml packages/mobile_app/pubspec.yaml

RUN flutter pub get

WORKDIR /workspace/packages/web_app
RUN flutter build web --release

FROM nginx:alpine
COPY --from=build /workspace/packages/web_app/build/web /usr/share/nginx/html
COPY packages/web_app/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
