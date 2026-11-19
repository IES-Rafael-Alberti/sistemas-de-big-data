const demo = db.getSiblingDB("sbd_demo");
demo.reservas.createIndex({reservation_id: 1}, {unique: true});
printjson(demo.reservas.findOne({reservation_id: "R0007"}, {_id: 0}));
printjson(demo.reservas.aggregate([
  {$match: {status: {$ne: "cancelled"}}},
  {$group: {_id: {channel: "$channel", month: {$substr: ["$stay.check_in", 0, 7]}}, ingresos: {$sum: "$pricing.total"}, reservas: {$sum: 1}}},
  {$sort: {"_id.month": 1, ingresos: -1}}
]).toArray());
