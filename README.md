# CoNote

シンプルなノート共有サービスです。

## demo site

https://co-note.herokuapp.com

## usage

1. ユーザ登録を行います。
1. 登録したユーザでログインします。
1. ノートを書きます。
1. グループを作ります。グループには３人まで他のユーザを登録できます。
1. ノートをグループに対して公開します。3グループまで公開できます。
1. グループに含まれて入るユーザは、ノートを閲覧できます。

## ローカルでのdevelopment起動

```bash
touch .env
docker-compose up -d
docker exec -it conote_rails /bin/bash --login
```

以下、コンテナ内

```bash
bundle install --path=vendor/bundle
bundle exec rake db:migrate
bundle exec rails s
```

## build

```bash
./build.sh
```

## deploy
事前にheroku-cli、appのセットアップが必要。

```bash
./deploy.sh
```