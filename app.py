from flask import Flask, jsonify

app = Flask(__name__)

@app.route('/')
def home():
    return jsonify({
        "status": "success",
        "project": "CrowdMind AI",
        "message": "Crowd management and disaster prevention system is active!",
        "version": "1.0.0"
    })

@app.route('/analytics')
def analytics():
    # Mock data for crowd monitoring
    return jsonify({
        "location": "Sector 62, Noida",
        "crowd_density": "High",
        "status": "Alert triggered - Safe routing suggested",
        "active_triggers": 1
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)