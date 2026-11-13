# 첫 번째 스테이지: 빌드 환경 설정
# ARM64 플랫폼을 지원하는 Gradle 8.5와 JDK 17 이미지 사용
FROM gradle:8.5-jdk17 as build

# 애플리케이션 홈 디렉토리 환경 변수 설정
ENV APP_HOME=/apps

# 작업 디렉토리 설정
WORKDIR $APP_HOME

# Gradle 관련 파일들을 먼저 복사 (의존성 캐싱을 위해)
COPY build.gradle settings.gradle gradlew $APP_HOME/

# Gradle Wrapper 디렉토리 복사
COPY gradle $APP_HOME/gradle

# gradlew 실행 권한 부여
RUN chmod +x gradlew

# 의존성 다운로드 (소스 코드 변경 시 재빌드 시간 단축을 위해)
RUN ./gradlew build || return 0

# 소스 코드 복사
COPY src $APP_HOME/src

# 전체 프로젝트 빌드 (테스트 포함)
RUN ./gradlew clean build

# 두 번째 스테이지: 실행 환경 설정
# 경량화된 OpenJDK 17 런타임 이미지 사용
FROM openjdk:17-jdk-slim

# 시스템 패키지 업데이트 및 필요한 도구들 설치
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    software-properties-common \
    git \
    && rm -rf /var/lib/apt/lists/*

# 애플리케이션 홈 디렉토리 환경 변수 설정
ENV APP_HOME=/apps

# 빌드된 JAR 파일의 새로운 이름 설정
ARG ARTIFACT_NAME=app.jar

# 빌드 스테이지에서 생성된 JAR 파일 경로
# ARG JAR_FILE_PATH=build/libs/[프로젝트명]-0.0.1-SNAPSHOT.jar 
ARG JAR_FILE_PATH=build/libs/ecs-springboot-0.0.1-SNAPSHOT.jar 

# 실행 환경의 작업 디렉토리 설정
WORKDIR $APP_HOME

# 빌드 스테이지에서 생성된 JAR 파일을 현재 스테이지로 복사
COPY --from=build $APP_HOME/$JAR_FILE_PATH $ARTIFACT_NAME

# Spring Boot 애플리케이션이 사용할 포트 노출
EXPOSE 8080

# 컨테이너 시작 시 실행될 명령어 (Spring Boot 애플리케이션 실행)
ENTRYPOINT ["java", "-jar", "app.jar"]

