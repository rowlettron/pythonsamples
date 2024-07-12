import keyring as kr

class security:

    def getPassword(self):
        pwd = kr.get_password("weather","python")
        return pwd
    
    def getWeatherKey(self):
        wk = kr.get_password("key","wkey")
        return wk

    def getWeatherHost(self):
        wh = kr.get_password("host","whost")
        return wh  

    

