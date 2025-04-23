from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from flask_jwt_extended import JWTManager, create_access_token, jwt_required, get_jwt_identity
from flask_cors import CORS
import datetime
import logging

logging.basicConfig(level=logging.DEBUG)

app = Flask(__name__)
CORS(app) 

# 配置数据库和 JWT 密钥
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///courseswap.db'
app.config['JWT_SECRET_KEY'] = 'your_secret_key'
db = SQLAlchemy(app)
jwt = JWTManager(app)

# 用户模型
class User(db.Model):
    id = db.Column(db.String(50), primary_key=True)
    email = db.Column(db.String(100), unique=True, nullable=False)
    password = db.Column(db.String(100), nullable=False)
    name = db.Column(db.String(100), default='New User')
    rating = db.Column(db.Float, default=0.0)

# 帖子模型
class SwapPost(db.Model):
    id = db.Column(db.String(50), primary_key=True)
    title = db.Column(db.String(200), nullable=False)
    description = db.Column(db.Text, nullable=False)
    author_id = db.Column(db.String(50), db.ForeignKey('user.id'), nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.datetime.utcnow)
    rating = db.Column(db.Float, default=0.0)
    author = db.relationship('User', backref=db.backref('posts', lazy=True))

# 初始化数据库
@app.before_first_request
def create_tables():
    db.create_all()

# 注册接口
@app.route('/register', methods=['POST'])
def register():
    logging.debug('Received registration request')
    data = request.get_json()
    email = data.get('email')
    password = data.get('password')

    if not email or not password:
        logging.error('Email and password are required')
        return jsonify({"error": "Email and password are required"}), 400

    if User.query.filter_by(email=email).first():
        logging.error('Email already exists')
        return jsonify({"error": "Email already exists"}), 400

    new_user = User(id=str(len(User.query.all()) + 1), email=email, password=password)
    try:
        db.session.add(new_user)
        db.session.commit()
        logging.info('User registered successfully')
        access_token = create_access_token(identity=new_user.id)
        return jsonify({
            "token": access_token,
            "user": {
                "id": new_user.id,
                "email": new_user.email,
                "name": new_user.name,
                "rating": new_user.rating
            }
        }), 201
    except Exception as e:
        db.session.rollback()
        logging.error(f'Error registering user: {str(e)}')
        return jsonify({"error": str(e)}), 500

# 登录接口
@app.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    email = data.get('email')
    password = data.get('password')

    user = User.query.filter_by(email=email, password=password).first()
    if user:
        access_token = create_access_token(identity=user.id)
        return jsonify({
            "token": access_token,
            "user": {
                "id": user.id,
                "email": user.email,
                "name": user.name,
                "rating": user.rating
            }
        }), 200
    else:
        return jsonify({"error": "Invalid email or password"}), 401

# 获取帖子列表接口
@app.route('/posts', methods=['GET'])
@jwt_required()
def get_posts():
    posts = SwapPost.query.all()
    post_list = [
        {
            "id": post.id,
            "title": post.title,
            "description": post.description,
            "authorId": post.author_id,
            "createdAt": post.created_at.isoformat(),
            "rating": post.rating
        }
        for post in posts
    ]
    return jsonify(post_list), 200

# 创建帖子接口
@app.route('/posts', methods=['POST'])
@jwt_required()
def create_post():
    logging.debug('Received create post request')
    data = request.get_json()
    title = data.get('title')
    description = data.get('description')

    if not title or not description:
        logging.error('Title and description are required')
        return jsonify({"error": "Title and description are required"}), 400

    user_id = get_jwt_identity()
    logging.debug(f'User {user_id} is trying to create a post')

    new_post = SwapPost(
        id=str(len(SwapPost.query.all()) + 1),
        title=title,
        description=description,
        author_id=user_id
    )
    try:
        db.session.add(new_post)
        db.session.commit()
        logging.info('Post created successfully')
        return jsonify({
            "id": new_post.id,
            "title": new_post.title,
            "description": new_post.description,
            "authorId": new_post.author_id,
            "createdAt": new_post.created_at.isoformat(),
            "rating": new_post.rating
        }), 201
    except Exception as e:
        db.session.rollback()
        logging.error(f'Error creating post: {str(e)}')
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True, port=8000)