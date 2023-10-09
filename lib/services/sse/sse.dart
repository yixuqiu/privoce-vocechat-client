// import 'dart:async';

// import 'package:universal_html/html.dart';
// import 'package:universal_html/html.dart' as html;
// import 'package:vocechat_client/app.dart';
// import 'package:vocechat_client/app_consts.dart';
// import 'package:vocechat_client/dao/org_dao/userdb.dart';
// import 'package:vocechat_client/shared_funcs.dart';

typedef ServerEventAware = void Function(dynamic);
typedef ServerEventReadyAware = void Function(bool ready);

// class Sse {
//   static final Sse sse = Sse._internal();

//   html.EventSource? eventSource;

//   Sse._internal();

//   final Set<ServerEventAware> serverEventListeners = {};
//   final Set<ServerEventReadyAware> readyListeners = {};

//   int reconnectSec = 1;

//   bool isConnecting = false;

//   Timer? _reconnectTimer;

//   void connect() async {
//     if (isConnecting) return;

//     isConnecting = true;
//     fireAfterReady(false);

//     close();
//     App.logger.info("Connecting SSE: ${await prepareUrl()}");
//     App.app.statusService?.fireSseLoading(SseStatus.connecting);

//     final eventSource =
//         html.EventSource(Uri.parse(await prepareUrl()).toString());

//     try {
//       eventSource.onMessage.listen((event) {
//         App.app.statusService?.fireSseLoading(SseStatus.successful);
//         App.logger.info(event.data);

//         if (event.data.toString().trim().isNotEmpty) {
//           fireSseEvent(event.data);
//         }

//         isConnecting = false;
//       });

//       eventSource.onOpen.listen((event) {
//         App.app.statusService?.fireSseLoading(SseStatus.successful);
//         reconnectSec = 1;
//         cancelReconnectionDelay();

//         isConnecting = false;
//       });

//       eventSource.onError.listen((event) {
//         App.app.statusService?.fireSseLoading(SseStatus.disconnected);
//         App.logger.severe(event);
//         App.logger.severe(event.type);
//         eventSource.close();
//         handleError(event);

//         isConnecting = false;
//       });
//     } catch (e) {
//       App.logger.severe(e);
//       isConnecting = false;
//       close();
//       App.app.statusService?.fireSseLoading(SseStatus.disconnected);
//     }

//     this.eventSource = eventSource;
//   }

//   void subscribeSseEvent(ServerEventAware aware) {
//     unsubscribeAllSseEvents();
//     serverEventListeners.add(aware);
//   }

//   void unsubscribeSseEvent(ServerEventAware aware) {
//     serverEventListeners.remove(aware);
//   }

//   void unsubscribeAllSseEvents() {
//     serverEventListeners.clear();
//   }

//   void subscribeReady(ServerEventReadyAware aware) {
//     unsubscribeReady(aware);
//     readyListeners.add(aware);
//   }

//   void unsubscribeReady(ServerEventReadyAware aware) {
//     readyListeners.remove(aware);
//   }

//   void unsubscribeAllReadyListeners() {
//     readyListeners.clear();
//   }

//   void fireSseEvent(dynamic event) {
//     for (ServerEventAware sseEventAware in serverEventListeners) {
//       try {
//         sseEventAware(event);
//       } catch (e) {
//         App.logger.severe(e);
//       }
//     }
//   }

//   void fireAfterReady(bool afterReady) {
//     for (ServerEventReadyAware aware in readyListeners) {
//       try {
//         aware(afterReady);
//       } catch (e) {
//         App.logger.severe(e);
//       }
//     }
//   }

//   Future<String> prepareUrl() async {
//     String url = "${App.app.chatServerM.fullUrl}/api/user/events?";

//     final afterMid = await UserDbMDao.dao.getMaxMid(App.app.userDb!.id);
//     // final afterMid = await ChatMsgDao().getMaxMid();
//     if (afterMid > -1) {
//       url += "after_mid=$afterMid";
//     }

//     final usersVersion = App.app.userDb!.usersVersion;
//     if (usersVersion > 0) {
//       url += "&users_version=$usersVersion";
//     }

//     url += "&api-key=${App.app.userDb!.token}";

//     return url;
//   }

//   void handleError(Event event) async {
//     _reconnectTimer = Timer(Duration(seconds: reconnectSec), () async {
//       if (await SharedFuncs.renewAuthToken(forceRefresh: true)) {
//         connect();
//       }

//       reconnectSec *= 2;
//       if (reconnectSec >= 64) {
//         reconnectSec = 64;
//       }
//     });
//   }

//   void cancelReconnectionDelay() {
//     _reconnectTimer?.cancel();
//   }

//   bool isClosed() {
//     if (eventSource == null) {
//       eventSource = null;
//       return true;
//     }
//     return eventSource?.readyState == html.EventSource.CLOSED;
//   }

//   void close() {
//     eventSource?.close();
//     eventSource = null;
//     isConnecting = false;
//     _reconnectTimer?.cancel();
//     App.logger.info("SSE Closed.");
//   }
// }
