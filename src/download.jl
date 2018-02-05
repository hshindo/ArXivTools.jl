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

function aaa()
    dt = now()
    y = Dates.year(dt)
    m = Dates.month(dt)
    d = Dates.day(dt)
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

function parsexml11(path::String)
    xml = readxml(path)
    arxivs = find(xml, "//arXiv")
    for arxiv in arxivs
        id = "arXiv" * nodecontent(findfirst(arxiv,"./id"))
        title = nodecontent(findfirst(arxiv,"./title"))
        abst = nodecontent(findfirst(arxiv,"./abstract"))

        doc = """
        <?xml version="1.0" encoding="UTF-8"?>
        <article>
        <front>
        <id>$id</id>
        <journal-title>arXiv</journal-title>
        <article-title>$title</article-title>
        <year>2016</year>
        <abstract>
        <p>$(strip(abst))</p>
        </abstract>
        </article>
        """

        #dir = joinpath()
        #isdir(dir) || mkdir(dir)
        #open(io -> print(io,doc), "$dir", "w")
    end
end
