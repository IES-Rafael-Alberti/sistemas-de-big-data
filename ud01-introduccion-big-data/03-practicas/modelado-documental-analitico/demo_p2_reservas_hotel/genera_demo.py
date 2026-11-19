import csv, json, random
from datetime import date, timedelta
from pathlib import Path

random.seed(20261029)
OUT = Path(__file__).parent / "data"
HOTELS = [("H001", "Hotel Costa Luz", "Cádiz", "ES", 4), ("H002", "Hotel Sierra Verde", "Granada", "ES", 3), ("H003", "Hotel Mar Azul", "Málaga", "ES", 5)]
ROOMS = {"standard": 95, "superior": 135, "suite": 220}
EXTRAS = {"breakfast": (18, "Desayuno"), "parking": (14, "Parking"), "spa": (35, "Acceso spa"), "transfer": (28, "Traslado")}
GUESTS = [("ES", "Madrid"), ("ES", "Sevilla"), ("PT", "Lisboa"), ("FR", "Toulouse"), ("DE", "Berlin"), ("GB", "Manchester"), ("IT", "Milán"), ("NL", "Utrecht")]
CHANNELS = ["direct_web", "booking", "expedia", "agencia"]
STATUSES = ["confirmed"] * 16 + ["checked_out"] * 5 + ["cancelled"] * 3

def main():
    OUT.mkdir(exist_ok=True); reservations, rows = [], []
    for i in range(1, 25):
        hid, hotel, city, country, stars = HOTELS[(i - 1) % 3]
        check_in = date(2026, 1, 5) + timedelta(days=(i * 7) % 250); nights = 1 + (i * 3) % 7
        check_out = check_in + timedelta(days=nights); oc, origin = GUESTS[(i * 3) % len(GUESTS)]
        room = ["standard", "superior", "suite"][i % 3]; rooms = 1 + i % 2; adults = rooms + i % 3; children = i % 2
        channel, status = CHANNELS[i % 4], STATUSES[i - 1]; services = []
        for key, (price, name) in EXTRAS.items():
            if (i + len(key)) % 4 == 0:
                qty = rooms if key in ("breakfast", "parking") else 1
                services.append({"code": key, "name": name, "quantity": qty, "unit_price": price, "total": qty * price})
        room_total = ROOMS[room] * rooms * nights; extras_total = sum(x["total"] for x in services); subtotal = room_total + extras_total; tax = round(subtotal * .10, 2); total = round(subtotal + tax, 2)
        r = {"reservation_id": f"R{i:04d}", "guest": {"guest_id": f"G{(i * 17) % 997:04d}", "origin_country": oc, "origin_city": origin}, "hotel": {"hotel_id": hid, "name": hotel, "city": city, "stars": stars}, "stay": {"check_in": check_in.isoformat(), "check_out": check_out.isoformat(), "nights": nights, "rooms": rooms, "room_type": room, "adults": adults, "children": children}, "channel": channel, "status": status, "extras": services, "pricing": {"room_total": room_total, "extras_total": extras_total, "tax": tax, "total": total}}
        reservations.append(r)
        items = [{"element_type": "room", "element_code": room, "quantity": rooms, "unit_price": ROOMS[room], "line_total": room_total}] + [{"element_type": "extra", "element_code": x["code"], "quantity": x["quantity"], "unit_price": x["unit_price"], "line_total": x["total"]} for x in services]
        for item in items: rows.append({"reservation_id": r["reservation_id"], "guest_id": r["guest"]["guest_id"], "hotel_id": hid, "hotel_city": city, "hotel_stars": stars, "origin_country": oc, "origin_city": origin, "check_in": check_in, "check_out": check_out, "nights": nights, "rooms": rooms, "adults": adults, "children": children, "room_type": room, "channel": channel, "status": status, **item, "tax_rate": .10, "reservation_total": total})
    (OUT / "reservas.ndjson").write_text("\n".join(json.dumps(x, ensure_ascii=False) for x in reservations) + "\n", encoding="utf-8")
    with (OUT / "reservas_elementos.csv").open("w", newline="", encoding="utf-8") as f: w = csv.DictWriter(f, fieldnames=rows[0]); w.writeheader(); w.writerows(rows)
    print(f"Generadas {len(reservations)} reservas y {len(rows)} elementos analíticos")
if __name__ == "__main__": main()
