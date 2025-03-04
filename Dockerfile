FROM gradle:4.10.0-jdk8
USER root
ENV SDK_URL="https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip" \
    ANDROID_HOME="/usr/local/android-sdk" \
    ANDROID_VERSION=23 \
    ANDROID_BUILD_TOOLS_VERSION=23.0.2
# Download Android SDK
RUN mkdir "$ANDROID_HOME" .android \
    && cd "$ANDROID_HOME" \
    && curl -o sdk.zip $SDK_URL \
    && unzip sdk.zip \
    && rm sdk.zip \
    && mkdir "$ANDROID_HOME/licenses" || true \
    && echo "24333f8a63b6825ea9c5514f83c2829b004d1fee" > "$ANDROID_HOME/licenses/android-sdk-license"
#    && yes | $ANDROID_HOME/tools/bin/sdkmanager --licenses
# Install Android Build Tool and Libraries
RUN $ANDROID_HOME/tools/bin/sdkmanager --update
RUN $ANDROID_HOME/tools/bin/sdkmanager "build-tools;${ANDROID_BUILD_TOOLS_VERSION}" \
    "platforms;android-${ANDROID_VERSION}" \
    "platform-tools"
RUN $ANDROID_HOME/tools/bin/sdkmanager  "extras;android;m2repository"
# Install Build Essentials
RUN apt-get update && apt-get install build-essential -y && apt-get install file -y && apt-get install apt-utils lib32stdc++6 lib32z1 -y
RUN mkdir /dist


WORKDIR /code
COPY . /code
# ENTRYPOINT ["/code/compile.sh"]
ENTRYPOINT ["/bin/bash"]