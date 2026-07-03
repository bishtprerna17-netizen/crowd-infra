# 1. Base image set karo (Python ka lightweight version)
FROM python:3.9-slim

# 2. Container ke andar apna working directory set karo
WORKDIR /app

# 3. Sabse pehle Flask library install karne ke liye use commands do
# (Hum direct run kar rahe hain taaki requirements file ka jhanjhat na ho abhi)
RUN pip install --no-cache-dir flask

# 4. Apne laptop ka 'app.py' container ke andar ke '/app' folder mein copy karo
COPY app.py .

# 5. Container ke andar kaun sa port kholna hai
EXPOSE 5000

# 6. Container start hote hi kaun si command chalegi
CMD ["python", "app.py"]