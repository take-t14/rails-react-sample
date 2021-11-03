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
ruby # vi Gemfile
※以下を追加
```
gem ‘react-rails’
```

ruby # bundle install
ruby # curl https://raw.githubusercontent.com/rails/webpacker/master/lib/install/config/webpacker.yml > config/webpacker.yml
ruby # npm install --global yarn
ruby # rails webpacker:install
ruby # rails webpacker:install:react
ruby # rails generate react:install
ruby # rails g react:component HelloWorld greeting:string
ruby # bundle exec rails webpacker:install:typescript
ruby # yarn add @types/react @types/react-dom
ruby # yarn add @material-ui/core

vi app/views/layouts/application.html.erb
※以下を追記
<%= javascript_pack_tag 'application' %>

※エラーが出る場合
https://qiita.com/sanriyochan/items/52780af6a9d77d8a14ba

#### # デバッグ
ruby # vi Gemfile
※以下を追加
```
gem "ruby-debug-ide"
gem "debase"
```
bundle install

#### # 複合主キー
ruby # vi Gemfile
※以下を追加
```
gem 'composite_primary_keys'
```
bundle install