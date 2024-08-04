from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

# Path to your ChromeDriver
chrome_driver_path = '/usr/bin/chromedriver'
service = Service(chrome_driver_path)

options = webdriver.ChromeOptions()
# Specify the path to the Brave executable
options.binary_location = '/usr/bin/brave'
options.add_argument('--app=chrome-extension://clngdbkpkpeebahjckkjfobafhncgmne/manage.html')

driver = webdriver.Chrome(service=service, options=options)
wait = WebDriverWait(driver, 10)

# Wait until the function importFromFile is available
wait.until(lambda driver: driver.execute_script('return typeof importFromFile === "function"'))

# Execute the function
driver.execute_script('importFromFile()')

# Keep the browser open for a few seconds to see the result
import time
time.sleep(5)

driver.quit()
