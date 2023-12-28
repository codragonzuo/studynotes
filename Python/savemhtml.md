# Save web html to mhtml file

```python
import time
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.expected_conditions import visibility_of_element_located
from selenium.webdriver.support.ui import WebDriverWait
import pyautogui

URL = 'https://en.wikipedia.org/wiki/Python_(programming_language)'
FILE_NAME = ''

# open page with selenium
# (first need to download Chrome webdriver, or a firefox webdriver, etc)
driver = webdriver.Chrome()
driver.get(URL)


# wait until body is loaded
WebDriverWait(driver, 60).until(visibility_of_element_located((By.TAG_NAME, 'body')))
time.sleep(1)
# open 'Save as...' to save html and assets
pyautogui.hotkey('ctrl', 's')
time.sleep(1)
if FILE_NAME != '':
    pyautogui.typewrite(FILE_NAME)
pyautogui.hotkey('enter')
```


