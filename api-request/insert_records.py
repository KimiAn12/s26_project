import psycopg2
import os
from api_request import mock_fetch_data


def connect_to_db():
    print("connecting to db")
    try:
        conn = psycopg2.connect(
            host=os.getenv("DB_HOST", "localhost"),
            port=int(os.getenv("DB_PORT", "5432")),
            dbname=os.getenv("DB_NAME", "my_weather_db"),
            user=os.getenv("DB_USER", "my_weather_user"),
            password=os.getenv("DB_PASSWORD", "my_weather_password"),
        )
        return conn
    except psycopg2.Error as e:
        print(f"Database connection failed: {e}")
        raise

def create_table(conn):
    print("creating table if not exists")
    try:
        cursor = conn.cursor()
        cursor.execute("""
            CREATE Schema IF NOT EXISTS dev;
            CREATE TABLE IF NOT EXISTS dev.raw_weather_data (
                id SERIAL PRIMARY KEY,
                city TEXT,
                temperature FLOAT,
                weather_description TEXT,
                wind_speed FLOAT,
                time TIMESTAMP,
                inserted_at TIMESTAMP DEFAULT NOW(),
                utc_offset TEXT
            );
        """)
        conn.commit()
        print("Table was created or already exists.")
    except psycopg2.Error as e:
        print(f"Failed to create table: {e}")
        raise

def insert_records(conn, data):
    print("inserting weather data")
    try:
        weather = data['current']
        location = data['location']
        cursor = conn.cursor()
        cursor.execute("""
            INSERT INTO dev.raw_weather_data (
                city,
                temperature,
                weather_description,
                wind_speed,
                time,
                inserted_at,
                utc_offset
            ) VALUES (%s, %s, %s, %s, %s, NOW(), %s)
        """,(
            location['name'],
            weather['temperature'],
            weather['weather_descriptions'][0],
            weather['wind_speed'],
            location['localtime'],
            location['utc_offset']
        ))
        conn.commit()
        print("Data successfully inserted.")
    except psycopg2.Error as e:
        print(f"Failed to insert records: {e}")
        raise

def main():
    try:
        data = mock_fetch_data()
        conn = connect_to_db()
        create_table(conn)
        insert_records(conn, data)
    except Exception as e:
        print(f"An error occurred during execution: {e}")
    finally:
        if 'conn' in locals():
            conn.close()
            print("Database connection closed.")


if __name__ == "__main__":
    main()


