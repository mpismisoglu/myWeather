import requests
from datetime import date
from flask import Flask, jsonify

def pre(woeid):
    currentDate = date.today()
    currentYear = currentDate.strftime("%Y")
    currentYear = int(currentYear)
    currentMonth = currentDate.strftime("%m")
    currentDay = currentDate.strftime("%d")
    mins = []
    maxs = []
    abbrs = []

    for i in range(7):
        req = requests.get("https://www.metaweather.com/api/location/" + str(woeid) + "/" + str(
            currentYear - i) + "/" + currentMonth + "/" + currentDay + "/")
        result = req.json()
        data = result[0]
        min = int(round(data["min_temp"]))
        max = int(round(data["max_temp"]))
        abbr = data["weather_state_abbr"]
        mins.append(min)
        maxs.append(max)
        abbrs.append(abbr)

    json_file = {}
    json_file["min"] = mins
    json_file["max"] = maxs
    json_file["abbr"] = abbrs
    return jsonify(json_file)


app = Flask(__name__)


@app.route('/')
def predict():
    return pre(44418)


if __name__ == '__main__':
    app.run()



