# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

####　# rubyのコンテナへ接続
mac # kubectl exec -it `kubectl get pod -n k8s-lampp-mac | grep ruby | grep Running | awk -F " " '{print $1}'` /bin/bash -n k8s-lampp-mac  

####　# コントローラー作成
ruby # rails generate controller product

＜PostgreSQL＞
https://mseeeen.msen.jp/rails-postgresql/

####　# モデルクラス作成
ruby # rails g model product product_id:integer product_group_id:integer product_name:text tax_rate:integer price:integer color_id:integer size_id:integer

####　# モデルクラス削除
ruby # rails destroy model product

####　# React
ruby # edit Gemfile
※以下を追加
```
gem ‘react-rails’
```

ruby # bundle install
ruby # rails webpacker:install
ruby # rails webpacker:install:react
ruby # rails generate react:install
ruby # rails g react:component HelloWorld greeting:string