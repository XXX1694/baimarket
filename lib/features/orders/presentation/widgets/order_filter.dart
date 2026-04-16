import '../../../../l10n/app_localizations.dart';

enum OrderFilter { all, active, completed, returns }

const _activeStatuses = <String>{
  'PAYMENT_PENDING',
  'PROCESSING',
  'ASSEMBLING',
  'WAY',
  'PICKUP',
};

const _completedStatuses = <String>{'DELIVERED'};

const _returnStatuses = <String>{
  'CANCELED',
  'ABANDONED',
  'PAYMENT_FAILED',
};

bool orderMatchesFilter(OrderFilter filter, String? status) {
  switch (filter) {
    case OrderFilter.all:
      return true;
    case OrderFilter.active:
      return _activeStatuses.contains(status);
    case OrderFilter.completed:
      return _completedStatuses.contains(status);
    case OrderFilter.returns:
      return _returnStatuses.contains(status);
  }
}

String orderFilterLabel(AppLocalizations l10n, OrderFilter filter) {
  switch (filter) {
    case OrderFilter.all:
      return l10n.ordersTabAll;
    case OrderFilter.active:
      return l10n.ordersTabActive;
    case OrderFilter.completed:
      return l10n.ordersTabCompleted;
    case OrderFilter.returns:
      return l10n.ordersTabReturn;
  }
}

OrderFilter orderFilterForStatus(String? status) {
  if (_activeStatuses.contains(status)) return OrderFilter.active;
  if (_completedStatuses.contains(status)) return OrderFilter.completed;
  if (_returnStatuses.contains(status)) return OrderFilter.returns;
  return OrderFilter.all;
}
