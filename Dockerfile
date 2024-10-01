# もととなるイメージを指定　continumio/anaconda3を指定
FROM continuumio/anaconda3
USER root
# 作業ディレクトリの指定 WORKDIR命令は該当のディレクトリが存在しな場合、ディレクトリを作成する。
# このディレクトリへのapp.pyファイルのコピーはバインドマウントで行うので、ここでは割愛

RUN apt update
RUN apt -y install locales && \
    localedef -f UTF-8 -i ja_JP ja_JP.UTF-8
ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP:ja
ENV LC_ALL ja_JP.UTF-8
ENV TZ JST-9
ENV TERM xterm

RUN apt install -y vim less
RUN apt install -y binutils

WORKDIR /usr/src/app

# コンテナ側のリッスンポート番号
# 明示しているだけで、なくても動く
EXPOSE 8888

COPY /requirements.txt ./

# イメージのビルド時にコマンドを実行
# イメージのビルド時にflaskをインストールするコマンドを実行 flaskは2.1.0をインストールする。
# RUN pip install flask==2.1.1

# イメージのビルド時にpipのアップグレードを実行
# pipをアップグレードし必要なパッケージをインストール
RUN pip install --upgrade pip && \
    pip install autopep8 && \
    pip install Keras && \
    pip install tensorflow 

RUN pip install -r requirements.txt

RUN python -m pip install jupyterlab

# ENTRYPOINT命令はコンテナ起動時に実行するコマンドを指定（基本docker runの時に上書きしないもの）
# "jupyter-lab" => jupyter-lab立ち上げコマンド
# "--ip=0.0.0.0" => ip制限なし
# "--port=8888" => EXPOSE命令で書いたポート番号と合わせる
# ”--no-browser” => ブラウザを立ち上げない。コンテナ側にはブラウザがないので 。
# "--allow-root" => rootユーザーの許可。セキュリティ的には良くないので、自分で使うときだけ。
# "--NotebookApp.token=''" => トークンなしで起動許可。これもセキュリティ的には良くない。
ENTRYPOINT ["jupyter-lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root", "--NotebookApp.token=''"]

# CMD命令はコンテナ起動時に実行するコマンドを指定（docker runの時に上書きする可能性のあるもの）
# "--notebook-dir=/workdir" => Jupyter Labのルートとなるディレクトリを指定
CMD ["--notebook-dir=/usr/src/app"]