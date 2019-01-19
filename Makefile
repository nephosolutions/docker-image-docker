#   Copyright 2019 NephoSolutions SPRL, Sebastian Trebitz
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

DOCKER_IMAGE_OWNER	:= nephosolutions
DOCKER_IMAGE_NAME		:= docker

DOCKER_VERSION := 18.09.1

CACHE_DIR 		:= .cache

remove = $(if $(strip $1),rm -rf $(strip $1))

$(DOCKER_IMAGE_OWNER)/$(DOCKER_IMAGE_NAME): restore
	docker build \
	--build-arg DOCKER_VERSION=$(DOCKER_VERSION) \
	--cache-from=$(DOCKER_IMAGE_OWNER)/$(DOCKER_IMAGE_NAME) \
	--tag $(DOCKER_IMAGE_OWNER)/$(DOCKER_IMAGE_NAME) .

$(CACHE_DIR)/$(DOCKER_IMAGE_OWNER)/$(DOCKER_IMAGE_NAME).tar: $(DOCKER_IMAGE_OWNER)/$(DOCKER_IMAGE_NAME)
	mkdir -p $(CACHE_DIR)/$(DOCKER_IMAGE_OWNER)
	docker save --output $(CACHE_DIR)/$(DOCKER_IMAGE_OWNER)/$(DOCKER_IMAGE_NAME).tar $(DOCKER_IMAGE_OWNER)/$(DOCKER_IMAGE_NAME)

clean:
	$(call remove,$(wildcard $(CACHE_DIR)))

restore:
	$(if $(wildcard $(CACHE_DIR)/$(DOCKER_IMAGE_OWNER)/$(DOCKER_IMAGE_NAME).tar),docker load --input $(CACHE_DIR)/$(DOCKER_IMAGE_OWNER)/$(DOCKER_IMAGE_NAME).tar)

.PHONY: clean restore $(DOCKER_IMAGE_OWNER)/$(DOCKER_IMAGE_NAME)
