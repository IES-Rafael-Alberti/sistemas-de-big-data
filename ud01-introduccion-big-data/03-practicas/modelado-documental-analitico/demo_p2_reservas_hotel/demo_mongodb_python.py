from pprint import pprint

from pymongo import ASCENDING, MongoClient


MONGO_URI = "mongodb://localhost:27017"


def main():
    client = MongoClient(MONGO_URI, serverSelectionTimeoutMS=3000)
    client.admin.command("ping")

    collection = client["sbd_demo"]["reservas"]
    collection.create_index([("reservation_id", ASCENDING)], unique=True)

    print("Reserva R0007:")
    pprint(collection.find_one({"reservation_id": "R0007"}, {"_id": 0}))

    pipeline = [
        {"$match": {"status": {"$ne": "cancelled"}}},
        {
            "$group": {
                "_id": {
                    "channel": "$channel",
                    "month": {"$substr": ["$stay.check_in", 0, 7]},
                },
                "ingresos": {"$sum": "$pricing.total"},
                "reservas": {"$sum": 1},
            }
        },
        {"$sort": {"_id.month": 1, "ingresos": -1}},
    ]

    print("Ingresos por canal y mes:")
    for result in collection.aggregate(pipeline):
        pprint(result)

    client.close()


if __name__ == "__main__":
    main()
