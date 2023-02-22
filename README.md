テーブルスキーマ

|  Task   |         |
| ------- | ------- |
| Column  | Type    |
| id      | integer |
| title   | string  |
| content | text    |



デプロイ手順
1. githubにアプリをpushする
2. heroku create アプリ名（今回はmanyo）でアプリ作成
3. heroku login -iでherokuにログイン。パスワードはherokuのAPIキー
4. heroku-22を使用するとデプロイ時にエラーが出るので、heroku-20を使用するため
   heroku stack:set heroku-20を実行する
5. git push heroku step2:master を実行してデプロイする。