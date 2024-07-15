from flask import Flask, jsonify, Response, render_template_string
import requests
import json

app = Flask(__name__)

def fetch_pharmacies():
    url = 'https://www.istanbuleczaciodasi.org.tr/nobetci-eczane/index.php'
    headers = {
        'accept': 'application/json, text/javascript, */*; q=0.01',
        'accept-language': 'tr-TR,tr;q=0.9,en-US;q=0.8,en;q=0.7',
        'content-type': 'application/x-www-form-urlencoded; charset=UTF-8',
        'cookie': 'COOKIE_DEVICE=desktop; PHPSESSID=0r64llsqqgc0epllfdcf2acbtt; _ga=GA1.3.1784100129.1720721554; _gid=GA1.3.1097795449.1720913974; _gat=1; _ga_7CRRPF1C9G=GS1.3.1720919248.3.1.1720919869.0.0.0',
        'origin': 'https://www.istanbuleczaciodasi.org.tr',
        'priority': 'u=1, i',
        'referer': 'https://www.istanbuleczaciodasi.org.tr/nobetci-eczane/',
        'sec-ch-ua': '"Not/A)Brand";v="8", "Chromium";v="126", "Google Chrome";v="126"',
        'sec-ch-ua-mobile': '?0',
        'sec-ch-ua-platform': '"macOS"',
        'sec-fetch-dest': 'empty',
        'sec-fetch-mode': 'cors',
        'sec-fetch-site': 'same-origin',
        'user-agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36',
        'x-requested-with': 'XMLHttpRequest'
    }
    data = {
        'jx': '1',
        'islem': 'get_eczane_markers',
        'h': '497a346e456b6538356d6a374d673d3d'
    }

    response = requests.post(url, headers=headers, data=data)
    response_text = response.text
    response_json = json.loads(response_text)
    print(response_json)  # Yanıtı yazdır

    pharmacies = response_json.get('eczaneler', [])
    return pharmacies

@app.route('/api/pharmacies', methods=['GET'])
def get_pharmacies():
    pharmacies = fetch_pharmacies()
    response_data = json.dumps(pharmacies, ensure_ascii=False, indent=2)
    response = Response(response_data, content_type='application/json; charset=utf-8')
    return response

@app.route('/pharmacies', methods=['GET'])
def display_pharmacies():
    pharmacies = fetch_pharmacies()
    response_data = json.dumps(pharmacies, ensure_ascii=False, indent=2)
    html_content = f"<html><body><pre>{response_data}</pre></body></html>"
    return html_content

if __name__ == '__main__':
    app.run(debug=True)
