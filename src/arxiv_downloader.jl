using EzXML

function downloadxml(date::Date)
    y, m, d = Dates.year(date), Dates.month(date), Dates.day(date)
    format(num::Int) = num < 10 ? "0$num" : "$num"
    ymd = "$y-$(format(m))-$(format(d))"
    baseuri = "http://export.arxiv.org/oai2?verb=ListRecords"
    uri = "$baseuri&metadataPrefix=arXiv&from=$ymd&until=$ymd"

    doc = XMLDocument()
    root = setroot!(doc, ElementNode("OAI-PMH"))
    records = link!(root, ElementNode("ListRecords"))
    while true
        xml = readxml(download(uri))
        for r in find(xml,"//record")
            unlink!(r)
            link!(records, r)
        end
        nodes = find(xml, "//resumptionToken")
        isempty(nodes) && break
        token = nodecontent(nodes[1])
        isempty(token) && break
        uri = "$baseuri&resumptionToken=$token"
        sleep(5)
    end
    write("arXiv$ymd.xml", doc)
end

function readxml(path::String)
    lines = open(readlines, path)
    @assert startswith(lines[2],"<OAI-PMH")
    lines[2] = "<OAI-PMH>"
    for i = 1:length(lines)
        startswith(lines[i]," <arXiv") && (lines[i] = " <arXiv>")
    end
    parsexml(join(lines,"\n"))
end

n = Date(now())
date = Date("2007-05-23")
while date < n
    println(date)
    downloadxml(date)
    date += Dates.Day(1)
    sleep(5)
end
