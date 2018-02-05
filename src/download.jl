using EzXML

function getxml(; from="", until="")
    baseuri = "http://export.arxiv.org/oai2?verb=ListRecords"
    uri = "$baseuri&metadataPrefix=arXiv"
    if !isempty(from)
        @assert !isempty(until)
        uri = "$uri&from=$from&until=$until"
    end

    while true
        xml = readxml(download(uri))
        nodes = find(xml, "//resumptionToken")
        isempty(nodes) && break
        token = nodecontent(nodes[1])
        uri = "$baseuri&resumptionToken=$token"
    end
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
