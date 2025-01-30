// import 'package:googleapis_auth/auth_io.dart';
//
// class GetServiceKey {
//   Future<String> getServiceKey() async {
//     final scopes = [
//       'https://www.googleapis.com/auth/userinfo.email',
//       'https://www.googleapis.com/auth/firebase.database',
//       'https://www.googleapis.com/auth/firebase.messaging'
//     ];
//
//     final client = await clientViaServiceAccount(
//         ServiceAccountCredentials.fromJson({
//           "type": "service_account",
//           "project_id": "bigtable-connect",
//           "private_key_id": "c02441dacd84781cc5abc6c4b6b53f7eef058244",
//           "private_key":
//               "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDUyhQcinW+P8dL\n4fEZ/ngDQAYF3iMBDU46yUHBFEjz9VnflYFQIuhbgMyaCjzxosysz2kZSc7VZ0Hs\nZKuSVoI1LPWO4DQYVMEcEjo/eWhFznwF6kDJyLogTlAacTypHNTT95IMXmKyyl1v\nNGAlyi2asvSnlrtK6ZyWxdG/SrLZXD5e6xN853JrIpC1LgtojtoXye6+Eq2d1HbU\nvzz4QB5QwwjwFejEVxtpUk9gXoq56fzLiFgbMKrQ6fwXdfo70WTyTd85JrDkylZn\nDOutejDvjlJmblyiqdF5EPmXN84wepg9Jgb3+fkyOn+8MrHCj1LhURAMBv65hu9C\nf3HzM4tJAgMBAAECggEALfqQR+5/LKG5XaMvpq8+nW0rH/90zthiK/+qzp6keNpu\nFgrHC1rPnF4DV9GYg5nq4fhbPFSfdas/KmZCUHeS4Qya7slxWESQCZHCtk50gojw\ncZLBdxiBZ1OkqWIIen45WqfnDfcjGoDxmYLWt7OtEP1UMhY22CQMauPJw6zPYnnQ\nJ058uO2cEvbUoGw3QC+DPrSC1TEKMVd3dloere/eUXzxmafp9GQ7fltejA6u3qY6\ni0AaYIvYC0PjFP+wNj3DOxDOaBYcqrCrVMeEAgcsXh1jK6IneE4/wFcmawYdugFc\nsUuKZgpCuYRNbFFHWGuj8TZx8jt+ElIAQC73CyfO1QKBgQDzmrvG4CczeKEnBE0J\n0g4igGpGzQFQTIdyFJSCylOZklqTMEz2dnkhIVGCzv2GlZapaIj2700VWqsxMI59\niku3kOjdQWBvB8vTGI4uXPTRvrU0MdIj1fuHJ7DaybpoLtvFYGZ3CK+HEsUVGf22\nUxD2S7fuphLog+6UXe6BbUh3vwKBgQDfnfBHiwK3ziJ5vU0eEj/vwVGQTR9U7C4A\nJOLQKTa5Llv3clktqox3g4SNTk5cdtATx8Br1/xgPSOBwtx5UG06PvSlP6kaKv5w\nskmTlMLwD64D64QIKXF1GPA0dO9dlHJk1CzZI6+9dQnfZ7ZoSZpNrD4ftGvdaYgJ\n3V4HPqh+9wKBgCCPtjnHDHZc0W2drY56fVkvQQVlsZ9CG3isN42j7bjBT0oNUrw+\n6cH76iFJ+albpV/PkT8wjWUlUWypyOIO8j//JqEsc+9jY2M8DQU1d6PxkdcAMc6I\nc66FJ6aXAEuct9OSJyASESRE5gMEDl2ojMPfKx7DJBPgTquWQqMaMG2RAoGBAIOJ\nDcunk2O3F0Rw+6nSplVLa8Tr+KAlhTGEgP5dH9lx0ZsOYjKgfZvXeuL7ytBM+zyH\nZUKKe+PIUtiDXNjnXDjEy3dgqQHBhIWZ+fmbqcc4Ee4wXSvH5PsyPik9F4f+SAPT\nYsYfXcKd077b7MoPcXp69NgFcuV8rA7Rbfvo+YglAoGBANiNyyBrU945PjNj2ENC\nyf8GNUGU1gySnFp6GaoHHRvY1K6YIZwLQqc9wR4L0py7D5oLGw95IUbav0+XvdYN\n7EfyPd5GGaYrmhnnfkPGmB6dwXToKmmLV2gvDbULHp0sI7rT6dofnzgVyMS1hBLR\nwehEtQYTx6M6nMzXAAxysg4f\n-----END PRIVATE KEY-----\n",
//           "client_email":
//               "firebase-adminsdk-fbsvc@bigtable-connect.iam.gserviceaccount.com",
//           "client_id": "111495748729270777671",
//           "auth_uri": "https://accounts.google.com/o/oauth2/auth",
//           "token_uri": "https://oauth2.googleapis.com/token",
//           "auth_provider_x509_cert_url":
//               "https://www.googleapis.com/oauth2/v1/certs",
//           "client_x509_cert_url":
//               "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40bigtable-connect.iam.gserviceaccount.com",
//           "universe_domain": "googleapis.com"
//         }),
//         scopes);
//     final accessServiceKey = client.credentials.accessToken.data;
//     return accessServiceKey;
//   }
// }
//
// Future<void> main() async {
//   GetServiceKey Key = GetServiceKey();
//
//   String serverKey = await Key.getServiceKey();
//   print(serverKey);
//   var key = "ya29.c.c0ASRK0GZZhy1HjXb4iICNyXhgY5pWOndGyRXNLslpazl1107njCTdY9Dz0lSx5uRM60OII2Wo1_OBymeXpGytEHK-vNnwk0sMFijatuN-8qxjnZux0l_6Z1vp8hBaOfcXGQlpS19fsg3bPEjYooAoVsFEzAEMN0wf7ewjlFK500RV7WeKGoPsCy0smabx4N6yk-bJJncVmkEVlN9CoBT1v6yI8fd3c3i2CbPRkQ8fpsa7hZJYrq-8WtVDfgPn2WRw5lG1ct8DkGNW6SYUW8BDFFzuv1xfSLicCRQvcR5ebROgVesgCnqQ6-gzsGs9vP0RukZpZL049T6V9vb5rD_ZA7vaT9uVEvxe8KGxzWFnUz-hKiaqRArAo_DTARMFH389CFBld7M-dzVurjmfet69x38o482xtlOMn_nuJ7d8m96BZqcbm_I26WuOYb96b7trlvjxop4s38ps24sawqp2tat_QVl73si0Vnu44nWfpwrde2bw5rVMYRdVt93OyYWbeRfBsiYy__tI-MaxuJgxkqZziv6z738vhxpWkW11IvgJp18ckwx0UUf4YViJqVhZlMvYR3h4xO2gy27p7Su-6WW49qsb9US30-56p5fprg1y8r5gviIWxR4udqWXg2J8gV9ROc985zk3JYMnyWo39Y32xIpdgosv__XpoMO8XI6ZV08Wto8v2wnW8rsawjOdomZYgmbvYqu7FcRpdg463U7j4tkSc7FkbgQB7RiIkzyrIodhFpMwvxsk-34-ZOMeBSIrk7wcYq39e5BZ565vq08hex2Og67q1wsmQMx56_xF9yUaYIxjd6IXecf4ixOa1VawejVZ4gpr9Os_7WMMwkUnFhnVz7t-OJSMpk5Oj9JUZ7YR7eOUhJk35cMui8VvaaihsnkkUeIthn5sdv7jsy5ec7k9eo3aMMvprciOmdj-z5fUc-a-yM21IvyiM4j2nsBtuk3Ybwk7wB9kRl0X6mOSkiUFRjt_JgyydoMxkjy_OybjVS4lh0V";
// }
