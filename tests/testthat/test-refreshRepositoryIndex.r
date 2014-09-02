context("package")

test_that("refreshRepositoryIndex", {

  .cleanTempDir <- function(x) {
    if (grepl(basename(tempdir()), x)) {
      unlink(x, recursive = TRUE, force = TRUE)
    }
  }
  
  repos  <- file.path(tempdir(), "repos")
  dir.create(repos, recursive=TRUE, showWarnings=FALSE)
  repos <- normalizePath(repos, winslash="/", mustWork=FALSE)
  repos_0 <- repos
  ensureRepository(repos)
  
  ## Character //
  expected <- TRUE
  expect_equal(res <- refreshRepositoryIndex( repos = repos), expected)
  
  ## RappPackageRepositoryS3 //
  repos <- asRepository(repos_0)
  expect_equal(res <- refreshRepositoryIndex( repos = repos), expected)
  
  ## RappExpandedPackageRepositoryS3 //
  repos <- asExpandedRepository(repos_0)
  expect_equal(res <- refreshRepositoryIndex( repos = repos), expected)
  
  ## RappPackageRepositoryMacBinaryS3
  ## RappPackageRepositoryWinBinaryS3
  ## RappPackageRepositorySourceS3
  repos <- asExpandedRepository(repos_0)
  sapply(seq(along=repos), function(ii) {
    expect_equivalent(res <- refreshRepositoryIndex(repos=repos[[ii]]), 
      expected)
  })
  
  ## Condition handling //
  .cleanTempDir(x = repos_0)
  expect_error(res <- refreshRepositoryIndex(repos = repos))
  
  on.exit(.cleanTempDir(x = repos_0))
  
  }
)
