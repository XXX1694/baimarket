# API Changes for Mobile Developer

## Overview

Added multi-seller support. Products can now belong to a specific **Seller** (продавец).  
Each seller has its own **Raffle** (лотерея/розыгрыш).  
Bai Market's own products have `seller.isOwn = true`.

---

## New: Seller Object

Seller возвращается внутри ответов на существующих и новых эндпоинтах.

```json
{
  "id": 1,
  "nameKz": "Bai Market",
  "nameRu": "Bai Market",
  "nameEn": "Bai Market",
  "slug": "bai-market",
  "isOwn": true
}
```

---

## New Endpoints: `/raffle`

### `GET /raffle`
Список активных розыгрышей.

**Response:**
```json
[
  {
    "id": 1,
    "startDate": "2026-04-01T00:00:00.000Z",
    "endDate": "2026-05-01T00:00:00.000Z",
    "isActive": true,
    "createdAt": "...",
    "seller": { "id": 2, "nameRu": "Продавец X", "slug": "seller-x", "isOwn": false, ... },
    "gifts": [
      { "id": 1, "name": "Подарок", "photoUrl": "..." }
    ]
  }
]
```

---

### `GET /raffle/:id`
Детали розыгрыша.

**Response:**
```json
{
  "id": 1,
  "startDate": "...",
  "endDate": "...",
  "isActive": true,
  "createdAt": "...",
  "seller": { ... },
  "gifts": [ ... ]
}
```

---

### `GET /raffle/:id/models?sort=popular`
Товары розыгрыша. Требует `id` розыгрыша.  
JWT опционален — если передан, возвращает `isInFavorite`.

**Query params:**

| Param | Values | Default |
|-------|--------|---------|
| `sort` | `popular` \| `cheap` \| `expensive` \| `discount` | `popular` |

**Response:**
```json
{
  "total": 25,
  "models": [
    {
      "id": 10,
      "name": "Кольцо золотое",
      "photoUrls": ["..."],
      "price": 45000,
      "oldPrice": 55000,
      "inStockCount": 3,
      "collections": [
        { "collection": { "slug": "lottery", "labelUrl": "..." } }
      ],
      "isInFavorite": false
    }
  ]
}
```

> Товары в наличии (`inStockCount > 0`) всегда идут первыми, затем — out of stock.

---

## Updated Endpoints

### `GET /category/by-collection/:slug?seller=`
Добавлен опциональный query param `seller`.

| Значение | Описание |
|----------|----------|
| `own` | Только товары Bai Market |
| `other` | Только товары сторонних продавцов |
| `{sellerId}` | Товары конкретного продавца (число) |
| *(не передан)* | Все товары (поведение без изменений) |

**Example:** `GET /category/by-collection/lottery?seller=own`

---

### `GET /model?sellerId=` и `GET /model/admin/all?sellerId=`
Добавлен опциональный query param `sellerId` (число).

**Example:** `GET /model?sellerId=2`

---

### `GET /model/:id`
Теперь в ответе есть поле `seller`:

```json
{
  "id": 42,
  "name": "...",
  "seller": {
    "id": 2,
    "nameKz": "...",
    "nameRu": "...",
    "nameEn": "...",
    "slug": "seller-x",
    "isOwn": false
  }
}
```

`seller` может быть `null` если модель не привязана к продавцу.

---

## Notes

- `isOwn: true` = товары самого Bai Market, `isOwn: false` = сторонний продавец.
- Раньше одна лотерея была общей. Теперь каждый продавец (`seller`) имеет свою лотерею.
