const puppeteer = require('puppeteer');
(async () => {
  const browser = await puppeteer.launch()
  const page = await browser.newPage()
  
  const navigationPromise = page.waitForNavigation()
  
  await page.goto('https://www.zeirishikensaku.jp/default.html')
  
  await page.setViewport({ width: 1920, height: 978 })
  
  let frames = await page.frames()
  const frame_2851 = frames.find(f => f.url() === 'https://www.zeirishikensaku.jp/sch/zs_sch0.asp')
  await frame_2851.waitForSelector('section > section:nth-child(5) > a > .site-title > img')
  await frame_2851.click('section > section:nth-child(5) > a > .site-title > img')
  
  await frame_2851.waitForSelector('div:nth-child(8) > table:nth-child(1) > tbody:nth-child(1) > tr:nth-child(1) > td:nth-child(1) > table:nth-child(1) > tbody:nth-child(1) > tr:nth-child(1) > .cell_3:nth-child(3) img:nth-child(1)')
  await frame_2851.click('div:nth-child(8) > table:nth-child(1) > tbody:nth-child(1) > tr:nth-child(1) > td:nth-child(1) > table:nth-child(1) > tbody:nth-child(1) > tr:nth-child(1) > .cell_3:nth-child(3) img:nth-child(1)')
  
  await navigationPromise
  
  await page.waitForSelector('table > tbody > tr:nth-child(7) > td > input')
  await page.click('table > tbody > tr:nth-child(7) > td > input')
  
  await page.waitForSelector('table > tbody > tr > td:nth-child(3) > input')
  await page.click('table > tbody > tr > td:nth-child(3) > input')
  
  await page.waitForSelector('tbody > tr > td > a > img')
  await page.click('tbody > tr > td > a > img')
  
  await navigationPromise
  
  await browser.close()
})()