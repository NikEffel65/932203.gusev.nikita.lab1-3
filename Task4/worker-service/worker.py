from flask import Flask, request
import pika

app = Flask(__name__)

@app.route('/api/orders', methods=['POST'])
def process_order():
    # Получение данных заказа из запроса
    order_data = request.get_json()
    
    # Отправка сообщения в очередь RabbitMQ
    connection = pika.BlockingConnection(pika.ConnectionParameters('rabbitmq'))
    channel = connection.channel()
    channel.queue_declare(queue='order_queue')
    channel.basic_publish(exchange='', routing_key='order_queue', body=str(order_data))
    connection.close()
    
    return 'Order sent to processing', 202

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)

