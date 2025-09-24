from fastapi import FastAPI
import uvicorn
from models.base import Base
from routes import auth, song
from database import engine

app = FastAPI(debug=True)

app.include_router(auth.router,prefix='/auth')
app.include_router(song.router, prefix='/song')



    #add the user to the db
    

Base.metadata.create_all(engine)