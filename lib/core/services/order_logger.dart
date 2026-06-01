import 'app_logger.dart';

/// Тег `ORDER` для flow создания и оплаты заказа.
const orderLog = AppLogger('ORDER');

/// Старое имя класса — оставлено для обратной совместимости.
@Deprecated('Use orderLog directly (AppLogger). Will be removed.')
class OrderLogger {
  const OrderLogger();
  void info(String message, [Object? data]) => orderLog.info(message, data);
  void warn(String message, [Object? data]) => orderLog.warn(message, data);
  void step(String message, [Object? data]) => orderLog.step(message, data);
  void api(String message, [Object? data]) => orderLog.api(message, data);
  void state(String message, [Object? data]) => orderLog.state(message, data);
  void nav(String message, [Object? data]) => orderLog.nav(message, data);
  void error(String message, [Object? data, Object? err, StackTrace? st]) =>
      orderLog.error(message, data, err, st);
}
