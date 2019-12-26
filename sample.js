const Http = new XMLHttpRequest();
const url='https://www.zeirishikensaku.jp/z_top2.asp';
Http.open("GET", url);
Http.send();

Http.onreadystatechange = (e) => {
  console.log(Http.responseText)
}