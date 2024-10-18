import os

with open("_build/sitemap.xml", "r") as f:
    sitemap = f.readlines()

sitemap = [x.replace("index.html", "") for x in sitemap]

with open("_build/sitemap.xml", "w") as f:
    f.writelines(sitemap)
