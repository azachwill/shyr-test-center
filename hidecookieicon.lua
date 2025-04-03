function Pandoc(doc)
local script = '<script src="/scripts/hidecookieicon.js"></script>'

-- Append the script at the end of the document
table.insert(doc.blocks, pandoc.RawBlock("footer", script))

return doc
end
