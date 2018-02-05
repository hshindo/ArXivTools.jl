using EzXML

function downloadxml(outpath::String; from="", until="")
    baseuri = "http://export.arxiv.org/oai2?verb=ListRecords"
    uri = "$baseuri&metadataPrefix=arXiv"
    if !isempty(from)
        @assert !isempty(until)
        uri = "$uri&from=$from&until=$until"
    end

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
        println("token=$token")
        uri = "$baseuri&resumptionToken=$token"
        sleep(5)
    end
    write(outpath, doc)
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

downloadxml("a.xml")
