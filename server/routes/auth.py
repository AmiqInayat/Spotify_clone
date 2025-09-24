import uuid
import bcrypt
from fastapi import Depends, HTTPException, Header

from database import get_db
from middleware.auth_middleware import auth_middleware
from models.user import User
from pydantic_schemas.login_user import UserLogin
from pydantic_schemas.user_create import UserCreate
from fastapi import APIRouter
from sqlalchemy.orm import Session
import jwt
from sqlalchemy.orm import joinedload

router = APIRouter()


@router.post('/signup', status_code= 201)

def signup_user(user: UserCreate, db: Session = Depends(get_db)):

    #check if the user already exists in db
    user_db=db.query(User).filter(User.email==user.email).first()


    if user_db:
        raise HTTPException(400,'User with the same email already exists')

    hashed_pw = bcrypt.hashpw(user.password.encode(), bcrypt.gensalt(16))
    user_db=User(id=str(uuid.uuid4()),name=user.name, email=user.email, password=hashed_pw)
    db.add(user_db)
    db.commit()
    db.refresh(user_db)

    return user_db

@router.post('/login')
def login_user(user: UserLogin, db: Session=Depends(get_db)):
    user_db= db.query(User).filter(User.email==user.email).first()

    if not user_db:
        raise HTTPException(400, 'User with this email does not exist!')
    
    print(type(user_db.password)) 
    
    is_match = bcrypt.checkpw(user.password.encode(), user_db.password) # pyright: ignore[reportArgumentType]

    if not is_match:
        raise HTTPException(400,'Incorrect Password')
    
    token = jwt.encode({'id':user_db.id}, 'password_key')
    
    return {'token': token, 'user': user_db}
    pass
@router.get('/')
def current_user_data(db: Session=Depends(get_db), 
                      user_dict = Depends(auth_middleware)):
    user = db.query(User).filter(User.id == user_dict['uid']).options(
        joinedload(User.favorites)
    ).first()

    if not user:
        raise HTTPException(404, 'User not found!')
    
    return user
    
