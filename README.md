# PlayTennisApp

По Postman c пушами 
BODY raw
to - "тут токен fcm который получаешь в getToken()"
{
    "to": "",
    "notification": {
      "title": "Пробую через http",
      "body": "I hope good"
      }
}
HEADER
Authorization key=Это в Firebase -> Project Setting -> Cloud Message -> Там Server Id есть 
Content-Type application/json
