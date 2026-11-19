from pprint import pprint
from pymongo import MongoClient, ASCENDING

client = MongoClient("mongodb://localhost:27017")
client.admin.command("ping")

db = client["sbd_demo"]
reservas = db["reservas"]

reservas.create_index(
    [("reservation_id", ASCENDING)],
    unique=True
)

# Recuperar una reserva
pprint(
    reservas.find_one(
        {"reservation_id": "R0007"},
        {
        "_id": 0,
        "reservation_id": 1,
        "channel": 1,
        "pricing.total": 1
    }
    )
)

# Agregar ingresos por canal y mes
pipeline = [
    {"$match": {"status": {"$ne": "cancelled"}}},
    {
        "$group": {
            "_id": {
                "channel": "$channel",
                "month": {"$substr": ["$stay.check_in", 0, 7]}
            },
            "ingresos": {"$sum": "$pricing.total"},
            "reservas": {"$sum": 1}
        }
    },
    {"$sort": {"_id.month": 1, "ingresos": -1}}
]


for resultado in reservas.aggregate(pipeline):
    pprint(resultado)

client.close()
