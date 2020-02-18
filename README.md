# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version 2.5.1

* System dependencies CentOS 7, MySQL 5.7.28, Apache

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

# 機能
※ -k オプションが必要な場合あり
## users ✔
### ユーザー登録＆ログイン ✔
> curl -X POST -H "Content-Type: application/json" -d '{"name":"TM", "email":"sgs@gmail.com", "sex":"M", "birthday":"2020-02-17", "place":"tokyo", "password":"reiwa"}' https://neo-tokyo.work:10282/users
- 実行成功 {“status”: “success”, “token”: [各ユーザーのToken]} ✔
- 実行失敗 {"status":"error"} ✔

### ユーザーログイン ✔
> curl -X POST -H "Content-Type: application/json" -d '{"email":"sgs@gmail.com", "password":"reiwa"}' https://neo-tokyo.work:10282/users/sign_in
- 実行成功 {“status”: “success”, “token”: [各ユーザーのToken]} ✔
- 実行失敗 {"status":"error"} ✔

### マイページ設定画面用GET ✔
> curl -H 'Authorization: Token [各ユーザーのToken]' https://neo-tokyo.work:10282/users/1

### ユーザー情報変更 ✔
> curl -X PUT -H "Content-Type: application/json" -H 'Authorization: Token [各ユーザーのToken]' -d '{"name":"TM", "email":"sgs@gmail.com", "sex":"M", "birthday":"1999-02-17", "place":"tokyo", "password":"reiwa"}' https://neo-tokyo.work:10282/users/1
- 実行成功 {"status":"success"} ✔
- 実行失敗 {"status":"error"} ✔

### ユーザー退会 ✔
> curl -X DELETE -H 'Authorization: Token [各ユーザーのToken]' https://neo-tokyo.work:10282/users/1
- 実行成功 {"status":"success"} ✔

## words
### word登録
> curl -k -X POST -H "Content-Type: application/json" -H 'Authorization: Token [各ユーザーのToken]' -d '{"name":"新型コロナウイルス"}' https://neo-tokyo.work:10282/words
- 既に登録されている場合 {"status":"already} ✔
- 実行成功 {"status":"success"} ✔
- 実行失敗 {"status":"error"} ✔
- fabsへの追加（サービスの特性上なくていいのでは[要相談]）

### word削除（サービスの特性上なくていいのでは）
> [未実装]

## fabs
### fab登録 ✔
> curl -X POST -H "Content-Type: application/json" -H 'Authorization: Token [各ユーザーのToken]' -d '{"word_id":"1"}' https://neo-tokyo.work:10282/fabs
- 既に登録されている場合 {"status":"already"} ✔
- 実行成功 {"status":"success"} ✔
- 実行失敗 {"status":"error"} ✔

### fab削除 ✔
> curl -X DELETE -H 'Authorization: Token [各ユーザーのToken]' https://neo-tokyo.work:10282/fabs/[word_id]
- 実行成功 {"status":"success"} ✔
- 実行失敗 {"status":"error"}

### fab検索(できればほしい) ✔
> curl -H 'Authorization: Token [各ユーザーのToken]' https://neo-tokyo.work:10282/fabs/[word_id]

### マイページ(自分のfabリスト) ✔
> curl -H 'Authorization: Token [各ユーザーのToken]' https://neo-tokyo.work:10282/fabs/mypage

## 検索系 [要相談]
### 必須パラメータ
- period: year, month
- page: 1, 2, 3, ...
### オプション
- age: 0, 10, 20, 30, 40, 50, 60, 70, 80, 90
- sex: M, W

> curl 'https://neo-tokyo.work:10282/fabs/api?period=month&sex=M&age=10&page=2'



# Reiwa初期API
## words
### POST
> curl -X POST -H "Content-Type: application/json" -d '{"name":"新型コロナウイルス", "user_id":"1", "tag_id":"1"}' https://neo-tokyo.work:10282/words
### DELETE
> curl -X DELETE https://neo-tokyo.work:10282/words/1
### PUT
> curl -X PUT -H "Content-Type: application/json" -d '{"name":"新型コロナウイルス", "user_id":"1", "tag_id":"1"}' https://neo-tokyo.work:10282/words/3

## fabs
### POST
> curl -X POST -H "Content-Type: application/json" -d '{"word_id":"1", "user_id":"1"}' https://neo-tokyo.work:10282/fabs
### DELETE
> curl -X DELETE https://neo-tokyo.work:10282/fabs/1
### PUT
> curl -X PUT -H "Content-Type: application/json" -d '{"word_id":"2", "user_id":"2"}' https://neo-tokyo.work:10282/fabs/1
### API
> curl 'https://neo-tokyo.work:10282/fabs/api?period=month&category=sex&private=True'

## users
### POST
> curl -X POST -H "Content-Type: application/json" -d '{"name":"TM", "email":"sgs@gmail.com", "sex":"M", "birthday":"2020-02-17", "place":"tokyo", "password":"reiwa"}' https://neo-tokyo.work:10282/users
### DELETE
> curl -X DELETE https://neo-tokyo.work:10282/users/3
### PUT
> curl -X PUT -H "Content-Type: application/json" -d '{"name":"TM", "email":"sgs@gmail.com", "sex":"M", "birthday":"2020-02-17", "place":"tokyo", "password":"reiwa"}' https://neo-tokyo.work:10282/users/8
