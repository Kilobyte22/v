(block
    (defun quit! () {
        v.exit()
    })

    (defun numbers (value) {
        v.buf.lineNumbers = scope.lvars.value:toBool()
        v.buf:update()
    })

    (defun status (message) {
        v.buf:setStatus(scope.lvars.message:toString())
    })

    (defun quit () (block
        (status "Use quit! to exit please")
        { os.sleep(4) }
    ))

    (alias q quit)
    (alias q! quit!)
)