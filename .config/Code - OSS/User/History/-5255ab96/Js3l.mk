LOTUS=lotus-system-x86_64

LOTUS_DISK?=-cdrom $(BOOTDISK)

LOTUS_FLAGS= \
	-m $(CONFIG_MEMORY)M \
	-serial mon:stdio \
	-rtc base=localtime \
	$(LOTUS_DISK)

ifeq ($(CONFIG_DISPLAY),sdl)
	LOTUS_FLAGS+=-display sdl
endif

LOTUS_FLAGS_VIRTIO=-device virtio-rng-pci \
				 -device virtio-serial \
				 -nic user,model=virtio-net-pci \
				 -vga virtio

.PHONY: run-lotus
run: $(BOOTDISK)
	@echo [LOTUS] $^
	@$(LOTUS) $(LOTUS_FLAGS) -enable-kvm -device ac97|| \
	 $(LOTUS) $(LOTUS_FLAGS) -enable-kvm -soundhw all

.PHONY: run-lotus-no-kvm
run-no-kvm: $(BOOTDISK)
	@echo [LOTUS] $^
	@$(LOTUS) $(LOTUS_FLAGS) -device ac97|| \
	 $(LOTUS) $(LOTUS_FLAGS) -soundhw all

.PHONY: run-lotus-virtio
run-virtio: $(BOOTDISK)
	@echo [LOTUS] $^
	@$(LOTUS) $(LOTUS_FLAGS) $(LOTUS_FLAGS_VIRTIO) -enable-kvm -device ac97|| \
	 $(LOTUS) $(LOTUS_FLAGS) $(LOTUS_FLAGS_VIRTIO) -enable-kvm -soundhw all
