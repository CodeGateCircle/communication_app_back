# README

## 環境セットアップ方法
1. `docker-compose build`でコンテナを立ち上げ
2. `docker-compose run web rails db:create`でデータベース作成
3. `docker-compose run web rails db:migrate`でマイグレーションファイルを実行
4. `docker-compose up`で実行