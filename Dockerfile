# Estagio 1: Build da Aplicacao com Gradle
FROM eclipse-temurin:21-jdk-jammy as builder
WORKDIR /app

# Copia os arquivos do Gradle wrapper e configs
COPY gradlew .
COPY gradle gradle
COPY build.gradle .
COPY settings.gradle .

# Dá permissão de execução para o gradlew
RUN chmod +x gradlew

# Faz download das dependências para cache
RUN ./gradlew dependencies --no-daemon || return 0

# Copia o código fonte
COPY src ./src

# Gera o JAR (sem rodar os testes)
RUN ./gradlew clean build -x test --no-daemon
# Estagio 2: Imagem Final de Execucao
FROM eclipse-temurin:21-jre-jammy
WORKDIR /app
COPY --from=builder /app/build/libs/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]